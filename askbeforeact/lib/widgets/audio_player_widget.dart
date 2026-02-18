import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Audio player widget for podcast playback
class AudioPlayerWidget extends StatefulWidget {
  final Uint8List? audioData;
  final VoidCallback? onGenerateAudio;
  final bool isGenerating;
  final String? error;

  const AudioPlayerWidget({
    super.key,
    this.audioData,
    this.onGenerateAudio,
    this.isGenerating = false,
    this.error,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  html.AudioElement? _audioElement;
  bool _isPlaying = false;
  double _currentPosition = 0.0;
  double _duration = 0.0;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    if (widget.audioData != null) {
      _initializeAudio();
    }
  }

  @override
  void didUpdateWidget(AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('🔄 AudioPlayerWidget didUpdateWidget called');
    print('📊 Old audio data: ${oldWidget.audioData?.length ?? 0} bytes');
    print('📊 New audio data: ${widget.audioData?.length ?? 0} bytes');
    
    if (widget.audioData != oldWidget.audioData && widget.audioData != null) {
      print('✅ Initializing audio with new data');
      _initializeAudio();
    }
  }

  @override
  void dispose() {
    _audioElement?.pause();
    _audioElement = null;
    super.dispose();
  }

  void _initializeAudio() {
    try {
      print('🎵 Initializing audio...');
      print('📊 Audio data size: ${widget.audioData!.length} bytes');
      
      // Dispose old audio element if exists
      if (_audioElement != null) {
        _audioElement!.pause();
        _audioElement = null;
      }
      
      // Detect audio format from magic bytes
      String mimeType = 'audio/wav'; // Default to WAV (Gemini typically returns WAV/PCM)
      if (widget.audioData!.length > 12) {
        final header = widget.audioData!.sublist(0, 12);
        print('📊 Audio header bytes: ${header.sublist(0, 4)}');
        
        // Check for common audio formats
        if (header[0] == 0xFF && (header[1] & 0xE0) == 0xE0) {
          mimeType = 'audio/mpeg'; // MP3
          print('🎵 Detected MP3 format');
        } else if (header[0] == 0x52 && header[1] == 0x49 && header[2] == 0x46 && header[3] == 0x46) {
          // RIFF header - check if it's WAV
          if (header[8] == 0x57 && header[9] == 0x41 && header[10] == 0x56 && header[11] == 0x45) {
            mimeType = 'audio/wav'; // WAV
            print('🎵 Detected WAV format (RIFF WAVE)');
          } else {
            mimeType = 'audio/x-wav';
            print('🎵 Detected RIFF format (trying audio/x-wav)');
          }
        } else if (header[0] == 0x4F && header[1] == 0x67 && header[2] == 0x67 && header[3] == 0x53) {
          mimeType = 'audio/ogg'; // OGG
          print('🎵 Detected OGG format');
        } else if (header[0] == 0x66 && header[1] == 0x4C && header[2] == 0x61 && header[3] == 0x43) {
          mimeType = 'audio/flac'; // FLAC
          print('🎵 Detected FLAC format');
        } else {
          print('⚠️ Unknown format (first bytes: ${header.sublist(0, 4)}), defaulting to audio/wav');
        }
      }
      
      // Create blob URL - try multiple MIME types if needed
      final mimeTypesToTry = [
        mimeType,
        'audio/wav',
        'audio/x-wav',
        'audio/mpeg',
        'audio/mp3',
        'audio/*',
      ].toSet().toList(); // Remove duplicates
      
      print('🔄 Will try MIME types: $mimeTypesToTry');
      
      for (final tryMimeType in mimeTypesToTry) {
        try {
          print('🔄 Trying MIME type: $tryMimeType');
          
          final blob = html.Blob([widget.audioData!], tryMimeType);
          print('✅ Blob created: ${blob.size} bytes');
          
          final url = html.Url.createObjectUrlFromBlob(blob);
          print('✅ URL created: $url');

          // Create audio element and set source
          _audioElement = html.AudioElement();
          _audioElement!.src = url;
          _audioElement!.preload = 'auto';
          _audioElement!.controls = false;
          
          print('✅ Audio element created with $tryMimeType');
          
          // Set up event listeners
          _audioElement!.onLoadedMetadata.listen((_) {
            print('✅ Audio metadata loaded, duration: ${_audioElement!.duration}s');
            if (mounted) {
              setState(() {
                _duration = _audioElement!.duration.toDouble();
              });
            }
          });

          _audioElement!.onTimeUpdate.listen((_) {
            if (mounted) {
              setState(() {
                _currentPosition = _audioElement!.currentTime.toDouble();
              });
            }
          });

          _audioElement!.onEnded.listen((_) {
            print('✅ Audio playback ended');
            if (mounted) {
              setState(() {
                _isPlaying = false;
                _currentPosition = 0.0;
              });
            }
          });

          _audioElement!.onError.listen((error) {
            print('❌ Audio playback error with $tryMimeType: $error');
            print('❌ Error code: ${_audioElement!.error?.code}');
            print('❌ Error message: ${_audioElement!.error?.message}');
            print('❌ Network state: ${_audioElement!.networkState}');
            print('❌ Ready state: ${_audioElement!.readyState}');
          });
          
          _audioElement!.onCanPlay.listen((_) {
            print('✅ Audio can play now with $tryMimeType!');
          });
          
          _audioElement!.onLoadedData.listen((_) {
            print('✅ Audio data loaded with $tryMimeType');
          });
          
          // Load the audio
          _audioElement!.load();
          print('✅ Audio load() called with $tryMimeType');
          
          // If we got here without exception, break the loop
          print('✅ Successfully initialized with $tryMimeType');
          break;
          
        } catch (e) {
          print('⚠️ Failed with $tryMimeType: $e');
          if (tryMimeType == mimeTypesToTry.last) {
            print('❌ All MIME types failed');
            rethrow;
          }
          // Try next MIME type
          continue;
        }
      }
      
    } catch (e, stackTrace) {
      print('❌ Error initializing audio: $e');
      print('❌ Stack trace: $stackTrace');
    }
  }

  void _togglePlayPause() {
    if (_audioElement == null) return;

    setState(() {
      if (_isPlaying) {
        _audioElement!.pause();
        _isPlaying = false;
      } else {
        _audioElement!.play();
        _isPlaying = true;
      }
    });
  }

  void _seek(double position) {
    if (_audioElement == null) return;
    _audioElement!.currentTime = position;
    setState(() {
      _currentPosition = position;
    });
  }

  void _changeSpeed(double speed) {
    if (_audioElement == null) return;
    _audioElement!.playbackRate = speed;
    setState(() {
      _playbackSpeed = speed;
    });
  }

  void _downloadAudio() {
    if (widget.audioData == null) return;

    try {
      print('💾 Downloading audio...');
      final blob = html.Blob([widget.audioData!], 'audio/mpeg');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', 'askbeforeact_podcast_${DateTime.now().millisecondsSinceEpoch}.mp3')
        ..click();
      
      // Clean up
      html.Url.revokeObjectUrl(url);
      print('✅ Audio download initiated');
    } catch (e) {
      print('❌ Error downloading audio: $e');
    }
  }

  String _formatDuration(double seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = (seconds % 60).floor();
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 AudioPlayerWidget build called');
    print('📊 audioData: ${widget.audioData?.length ?? 0} bytes');
    print('📊 isGenerating: ${widget.isGenerating}');
    print('📊 error: ${widget.error}');
    
    // Show generate button if no audio
    if (widget.audioData == null && !widget.isGenerating) {
      print('➡️ Showing generate button');
      return _buildGenerateButton();
    }

    // Show loading state
    if (widget.isGenerating) {
      print('➡️ Showing loading state');
      return _buildLoadingState();
    }

    // Show error state
    if (widget.error != null) {
      print('➡️ Showing error state');
      return _buildErrorState();
    }

    // Show audio player
    print('➡️ Showing audio player');
    return _buildPlayer();
  }

  Widget _buildGenerateButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.headphones,
            size: 48,
            color: Color(0xFF3B82F6),
          ),
          const SizedBox(height: 12),
          const Text(
            'Generate Audio Podcast',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Listen to this summary with AI-generated voice',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: widget.onGenerateAudio,
            icon: const Icon(Icons.mic),
            label: const Text('Generate Audio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Generating audio with Gemini AI...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This may take 10-30 seconds',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Color(0xFFEF4444),
          ),
          const SizedBox(height: 12),
          const Text(
            'Audio Generation Failed',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.error ?? 'Unknown error',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: widget.onGenerateAudio,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3B82F6).withOpacity(0.1),
            const Color(0xFF2563EB).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Play/Pause button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  size: 64,
                  color: const Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Progress bar
          Column(
            children: [
              Slider(
                value: _currentPosition,
                max: _duration > 0 ? _duration : 1.0,
                onChanged: _seek,
                activeColor: const Color(0xFF3B82F6),
                inactiveColor: const Color(0xFF3B82F6).withOpacity(0.3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_currentPosition),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Speed control
              PopupMenuButton<double>(
                initialValue: _playbackSpeed,
                onSelected: _changeSpeed,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.speed, size: 18, color: Color(0xFF3B82F6)),
                      const SizedBox(width: 4),
                      Text(
                        '${_playbackSpeed}x',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 0.5, child: Text('0.5x')),
                  const PopupMenuItem(value: 0.75, child: Text('0.75x')),
                  const PopupMenuItem(value: 1.0, child: Text('1.0x (Normal)')),
                  const PopupMenuItem(value: 1.25, child: Text('1.25x')),
                  const PopupMenuItem(value: 1.5, child: Text('1.5x')),
                  const PopupMenuItem(value: 2.0, child: Text('2.0x')),
                ],
              ),
              
              // Download button
              ElevatedButton.icon(
                onPressed: _downloadAudio,
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Download'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
              
              // Regenerate button
              OutlinedButton.icon(
                onPressed: widget.onGenerateAudio,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Regenerate'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF3B82F6),
                  side: const BorderSide(color: Color(0xFF3B82F6)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
