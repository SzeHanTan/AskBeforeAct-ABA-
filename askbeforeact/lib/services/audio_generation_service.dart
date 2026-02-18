import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../core/config/env_config.dart';

/// Service for generating audio from text using Gemini 2.5 TTS
class AudioGenerationService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  
  /// Available voice options for Gemini TTS
  static const List<Map<String, String>> availableVoices = [
    {'name': 'Puck', 'description': 'Energetic and upbeat - Perfect for podcasts'},
    {'name': 'Charon', 'description': 'Deep and authoritative - Professional tone'},
    {'name': 'Kore', 'description': 'Warm and friendly - Conversational style'},
    {'name': 'Fenrir', 'description': 'Strong and confident - News anchor style'},
    {'name': 'Aoede', 'description': 'Soft and soothing - Calm narration'},
  ];

  /// Generate audio from text using Gemini 2.5 TTS
  /// 
  /// Parameters:
  /// - [text]: The script to convert to audio
  /// - [voiceName]: Voice to use (default: 'Puck' for energetic podcast tone)
  /// - [model]: Gemini model to use (default: 'gemini-2.5-flash-preview-tts')
  /// 
  /// Returns: Audio data as Uint8List (MP3/PCM format)
  Future<Uint8List> generateAudio({
    required String text,
    String voiceName = 'Puck',
    String model = 'gemini-2.5-flash-preview-tts',
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/models/$model:generateContent?key=${EnvConfig.geminiApiKey}'
      );

      // Prepare request body according to Gemini API format
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': text}
            ]
          }
        ],
        'generationConfig': {
          'responseModalities': ['AUDIO'], // Request audio output
          'speechConfig': {
            'voiceConfig': {
              'prebuiltVoiceConfig': {
                'voiceName': voiceName
              }
            }
          }
        }
      };

      print('🎙️ Generating audio with Gemini TTS...');
      print('📝 Text length: ${text.length} characters');
      print('🎤 Voice: $voiceName');
      print('🤖 Model: $model');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        // Extract audio data from response
        // The audio is in candidates[0].content.parts[0].inlineData.data
        final candidates = jsonResponse['candidates'] as List?;
        if (candidates == null || candidates.isEmpty) {
          throw Exception('No audio generated in response');
        }

        final content = candidates[0]['content'] as Map<String, dynamic>?;
        if (content == null) {
          throw Exception('No content in response');
        }

        final parts = content['parts'] as List?;
        if (parts == null || parts.isEmpty) {
          throw Exception('No parts in response');
        }

        final inlineData = parts[0]['inlineData'] as Map<String, dynamic>?;
        if (inlineData == null) {
          throw Exception('No inline data in response');
        }

        final audioBase64 = inlineData['data'] as String?;
        if (audioBase64 == null) {
          throw Exception('No audio data in response');
        }
        
        final mimeType = inlineData['mimeType'] as String?;
        print('📊 Audio MIME type from Gemini: $mimeType');

        // Decode base64 audio data
        final audioBytes = base64Decode(audioBase64);
        
        print('✅ Audio generated successfully!');
        print('📊 Audio size: ${audioBytes.length} bytes (${(audioBytes.length / 1024).toStringAsFixed(2)} KB)');
        print('📊 First 20 bytes: ${audioBytes.take(20).toList()}');
        
        // Check if audio already has WAV header
        final hasWavHeader = audioBytes.length > 12 &&
            audioBytes[0] == 0x52 && audioBytes[1] == 0x49 && // "RI"
            audioBytes[2] == 0x46 && audioBytes[3] == 0x46 && // "FF"
            audioBytes[8] == 0x57 && audioBytes[9] == 0x41 && // "WA"
            audioBytes[10] == 0x56 && audioBytes[11] == 0x45; // "VE"
        
        if (hasWavHeader) {
          print('✅ Audio already has WAV header');
          return audioBytes;
        } else {
          print('⚠️ Audio is raw PCM, adding WAV header...');
          // Gemini returns raw PCM data, we need to add WAV headers
          final wavBytes = _addWavHeader(audioBytes);
          print('✅ WAV header added, new size: ${wavBytes.length} bytes');
          print('📊 First 20 bytes with header: ${wavBytes.take(20).toList()}');
          return wavBytes;
        }
      } else {
        final errorBody = response.body;
        print('❌ Error generating audio: ${response.statusCode}');
        print('Error details: $errorBody');
        throw Exception('Failed to generate audio: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      print('❌ Exception in generateAudio: $e');
      throw Exception('Failed to generate audio: $e');
    }
  }

  /// Generate audio with enhanced podcast formatting
  /// Adds natural pauses and emphasis to the script
  Future<Uint8List> generatePodcastAudio({
    required String script,
    String voiceName = 'Puck',
    String tone = 'casual',
  }) async {
    try {
      // Enhance script with natural pauses for better podcast flow
      final enhancedScript = _enhanceScriptForAudio(script, tone);
      
      return await generateAudio(
        text: enhancedScript,
        voiceName: voiceName,
      );
    } catch (e) {
      throw Exception('Failed to generate podcast audio: $e');
    }
  }

  /// Enhance script with natural pauses and formatting
  String _enhanceScriptForAudio(String script, String tone) {
    // Add pauses after sentences for natural flow
    String enhanced = script
        .replaceAll('!', '! ') // Pause after exclamations
        .replaceAll('?', '? ') // Pause after questions
        .replaceAll('.', '. ') // Pause after sentences
        .replaceAll('  ', ' '); // Remove double spaces

    // Add tone context at the beginning
    String tonePrompt = '';
    switch (tone.toLowerCase()) {
      case 'casual':
        tonePrompt = '[Speaking in a casual, friendly, conversational tone] ';
        break;
      case 'professional':
        tonePrompt = '[Speaking in a professional, authoritative tone] ';
        break;
      case 'energetic':
        tonePrompt = '[Speaking with energy and enthusiasm] ';
        break;
      case 'calm':
        tonePrompt = '[Speaking in a calm, soothing tone] ';
        break;
      default:
        tonePrompt = '';
    }

    return tonePrompt + enhanced;
  }

  /// Get recommended voice for a given tone
  String getRecommendedVoice(String tone) {
    switch (tone.toLowerCase()) {
      case 'casual':
      case 'energetic':
        return 'Puck'; // Energetic and upbeat
      case 'professional':
        return 'Charon'; // Deep and authoritative
      case 'friendly':
        return 'Kore'; // Warm and friendly
      case 'news':
        return 'Fenrir'; // Strong and confident
      case 'calm':
        return 'Aoede'; // Soft and soothing
      default:
        return 'Puck'; // Default to energetic
    }
  }

  /// Check if audio generation is available
  Future<bool> isAudioGenerationAvailable() async {
    try {
      // Test with a short text
      await generateAudio(
        text: 'Test',
        voiceName: 'Puck',
      );
      return true;
    } catch (e) {
      print('Audio generation not available: $e');
      return false;
    }
  }

  /// Get estimated audio duration in seconds
  /// Rough estimate: ~150 words per minute for podcast
  int estimateAudioDuration(String text) {
    final wordCount = text.split(RegExp(r'\s+')).length;
    final minutes = wordCount / 150; // 150 words per minute
    return (minutes * 60).ceil(); // Convert to seconds
  }

  /// Format duration for display
  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Add WAV header to raw PCM data
  /// Gemini returns raw PCM (Linear16) at 24kHz, mono
  Uint8List _addWavHeader(Uint8List pcmData) {
    final int sampleRate = 24000; // 24kHz (Gemini default)
    final int numChannels = 1; // Mono
    final int bitsPerSample = 16; // 16-bit PCM
    final int byteRate = sampleRate * numChannels * (bitsPerSample ~/ 8);
    final int blockAlign = numChannels * (bitsPerSample ~/ 8);
    final int dataSize = pcmData.length;
    final int fileSize = 36 + dataSize; // 44 bytes header - 8 bytes

    // Create WAV header (44 bytes)
    final header = <int>[
      // RIFF chunk descriptor
      0x52, 0x49, 0x46, 0x46, // "RIFF"
      fileSize & 0xff, (fileSize >> 8) & 0xff, (fileSize >> 16) & 0xff, (fileSize >> 24) & 0xff, // File size
      0x57, 0x41, 0x56, 0x45, // "WAVE"
      
      // fmt sub-chunk
      0x66, 0x6d, 0x74, 0x20, // "fmt "
      16, 0, 0, 0, // Subchunk1Size (16 for PCM)
      1, 0, // AudioFormat (1 for PCM)
      numChannels, 0, // NumChannels
      sampleRate & 0xff, (sampleRate >> 8) & 0xff, (sampleRate >> 16) & 0xff, (sampleRate >> 24) & 0xff, // SampleRate
      byteRate & 0xff, (byteRate >> 8) & 0xff, (byteRate >> 16) & 0xff, (byteRate >> 24) & 0xff, // ByteRate
      blockAlign, 0, // BlockAlign
      bitsPerSample, 0, // BitsPerSample
      
      // data sub-chunk
      0x64, 0x61, 0x74, 0x61, // "data"
      dataSize & 0xff, (dataSize >> 8) & 0xff, (dataSize >> 16) & 0xff, (dataSize >> 24) & 0xff, // Subchunk2Size
    ];

    // Combine header and PCM data
    final wavData = Uint8List(44 + dataSize);
    wavData.setRange(0, 44, header);
    wavData.setRange(44, 44 + dataSize, pcmData);

    return wavData;
  }
}
