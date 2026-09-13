import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'review_incident_screen.dart';

class UploadIncidentScreen extends StatefulWidget {
  final String incidentType;
  final String severity;
  final String description;

  const UploadIncidentScreen({
    super.key,
    required this.incidentType,
    required this.severity,
    required this.description,
  });

  @override
  State<UploadIncidentScreen> createState() =>
      _UploadIncidentScreenState();
}

class _UploadIncidentScreenState extends State<UploadIncidentScreen> {
  static const Color primaryBlue = Color(0xFF1769E0);
  static const Color darkBlue = Color(0xFF123B70);
  static const Color background = Color(0xFFF7F9FC);
  static const Color softBlue = Color(0xFFEAF2FF);
  static const Color textDark = Color(0xFF172033);
  static const Color textGrey = Color(0xFF697386);

  final ImagePicker _picker = ImagePicker();

  final List<XFile> selectedPhotos = [];
  XFile? selectedVideo;

  bool isPickingPhoto = false;
  bool isPickingVideo = false;

  // ------------------------------------------------------------
  // PHOTO PICKER
  // ------------------------------------------------------------

  Future<void> _pickPhotos() async {
    if (selectedPhotos.length >= 5) {
      _showMessage('Maximum 5 photos allowed.');
      return;
    }

    if (isPickingPhoto || isPickingVideo) return;

    setState(() {
      isPickingPhoto = true;
    });

    try {
      final int remaining = 5 - selectedPhotos.length;

      final List<XFile> images =
          await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (!mounted) return;

      if (images.isEmpty) {
        return;
      }

      final List<XFile> imagesToAdd =
          images.take(remaining).toList();

      setState(() {
        selectedPhotos.addAll(imagesToAdd);
      });

      if (images.length > remaining) {
        _showMessage(
          'Only $remaining more photo(s) could be added.',
        );
      }
    } catch (e) {
      debugPrint('PHOTO PICKER ERROR: $e');

      if (mounted) {
        _showMessage(
          'Photo selection failed. Please check gallery permission.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isPickingPhoto = false;
        });
      }
    }
  }

  // ------------------------------------------------------------
  // CAMERA PHOTO
  // ------------------------------------------------------------

  Future<void> _takePhoto() async {
    if (selectedPhotos.length >= 5) {
      _showMessage('Maximum 5 photos allowed.');
      return;
    }

    if (isPickingPhoto || isPickingVideo) return;

    setState(() {
      isPickingPhoto = true;
    });

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (!mounted) return;

      if (image != null) {
        setState(() {
          selectedPhotos.add(image);
        });
      }
    } catch (e) {
      debugPrint('CAMERA ERROR: $e');

      if (mounted) {
        _showMessage(
          'Camera could not be opened. Please check permission.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isPickingPhoto = false;
        });
      }
    }
  }

  // ------------------------------------------------------------
  // VIDEO PICKER
  // ------------------------------------------------------------

  Future<void> _pickVideo() async {
    if (isPickingPhoto || isPickingVideo) return;

    setState(() {
      isPickingVideo = true;
    });

    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (!mounted) return;

      if (video != null) {
        setState(() {
          selectedVideo = video;
        });
      }
    } catch (e) {
      debugPrint('VIDEO PICKER ERROR: $e');

      if (mounted) {
        _showMessage(
          'Video selection failed. Please check gallery permission.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isPickingVideo = false;
        });
      }
    }
  }

  // ------------------------------------------------------------
  // CAMERA VIDEO
  // ------------------------------------------------------------

  Future<void> _recordVideo() async {
    if (isPickingPhoto || isPickingVideo) return;

    setState(() {
      isPickingVideo = true;
    });

    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 2),
      );

      if (!mounted) return;

      if (video != null) {
        setState(() {
          selectedVideo = video;
        });
      }
    } catch (e) {
      debugPrint('VIDEO CAMERA ERROR: $e');

      if (mounted) {
        _showMessage(
          'Camera could not record video. Please check permission.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isPickingVideo = false;
        });
      }
    }
  }

  // ------------------------------------------------------------
  // PHOTO OPTIONS
  // ------------------------------------------------------------

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Add Photo',
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 18),

                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: softBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.photo_library_outlined,
                      color: primaryBlue,
                    ),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text(
                    'Select one or multiple photos',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickPhotos();
                  },
                ),

                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: softBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: primaryBlue,
                    ),
                  ),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text(
                    'Use your phone camera',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // VIDEO OPTIONS
  // ------------------------------------------------------------

  void _showVideoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 22),

                const Text(
                  'Add Video',
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 18),

                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: softBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.video_library_outlined,
                      color: primaryBlue,
                    ),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text(
                    'Select an existing video',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickVideo();
                  },
                ),

                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: softBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.videocam_outlined,
                      color: primaryBlue,
                    ),
                  ),
                  title: const Text(
                    'Record a Video',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text(
                    'Use your phone camera',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _recordVideo();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // REMOVE PHOTO
  // ------------------------------------------------------------

  void _removePhoto(int index) {
    setState(() {
      selectedPhotos.removeAt(index);
    });
  }

  // ------------------------------------------------------------
  // REMOVE VIDEO
  // ------------------------------------------------------------

  void _removeVideo() {
    setState(() {
      selectedVideo = null;
    });
  }

  // ------------------------------------------------------------
  // MESSAGE
  // ------------------------------------------------------------

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkBlue,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // NEXT
  // ------------------------------------------------------------

  void _nextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewIncidentScreen(
          incidentType: widget.incidentType,
          severity: widget.severity,
          description: widget.description,
          photoCount: selectedPhotos.length,
          videoAdded: selectedVideo != null,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkBlue,
            size: 19,
          ),
        ),

        title: const Text(
          'Report Incident',
          style: TextStyle(
            color: darkBlue,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            18,
            8,
            18,
            30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildProgress(),

              const SizedBox(height: 30),

              const Text(
                'Add evidence',
                style: TextStyle(
                  color: textDark,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Photos and videos help authorities understand the situation better.',
                style: TextStyle(
                  color: textGrey,
                  fontSize: 13,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 28),

              _buildSectionHeader(
                title: 'Photos',
                subtitle: 'Add up to 5 photos',
                count: '${selectedPhotos.length}/5',
              ),

              const SizedBox(height: 14),

              _buildPhotoSection(),

              const SizedBox(height: 28),

              _buildSectionHeader(
                title: 'Video',
                subtitle: 'Add one video if available',
                count: selectedVideo == null
                    ? 'Optional'
                    : 'Added',
              ),

              const SizedBox(height: 14),

              _buildVideoSection(),

              const SizedBox(height: 32),

              _buildInfoCard(),

              const SizedBox(height: 28),

              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required String count,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: textGrey,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: softBlue,
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: Text(
            count,
            style: const TextStyle(
              color: primaryBlue,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PHOTO SECTION
  // ============================================================

  Widget _buildPhotoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: selectedPhotos.isEmpty
          ? _buildEmptyPhotoState()
          : _buildPhotoGrid(),
    );
  }

  Widget _buildEmptyPhotoState() {
    return GestureDetector(
      onTap: isPickingPhoto
          ? null
          : _showPhotoOptions,
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          color: softBlue,
          borderRadius:
              BorderRadius.circular(14),
          border: Border.all(
            color:
                primaryBlue.withOpacity(0.15),
          ),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration:
                  const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: isPickingPhoto
                  ? const Padding(
                      padding:
                          EdgeInsets.all(17),
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: primaryBlue,
                      ),
                    )
                  : const Icon(
                      Icons
                          .add_photo_alternate_outlined,
                      color: primaryBlue,
                      size: 29,
                    ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Add photos',
              style: TextStyle(
                color: darkBlue,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'Gallery or camera',
              style: TextStyle(
                color: textGrey,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PHOTO GRID
  // ============================================================

  Widget _buildPhotoGrid() {
    final int itemCount =
        selectedPhotos.length < 5
            ? selectedPhotos.length + 1
            : selectedPhotos.length;

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 9,
        mainAxisSpacing: 9,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        if (index == selectedPhotos.length) {
          return _buildAddPhotoTile();
        }

        return _buildPhotoTile(
          selectedPhotos[index],
          index,
        );
      },
    );
  }

  Widget _buildAddPhotoTile() {
    return GestureDetector(
      onTap: _showPhotoOptions,
      child: Container(
        decoration: BoxDecoration(
          color: softBlue,
          borderRadius:
              BorderRadius.circular(14),
          border: Border.all(
            color:
                primaryBlue.withOpacity(0.18),
          ),
        ),
        child: const Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              color: primaryBlue,
              size: 28,
            ),
            SizedBox(height: 4),
            Text(
              'Add',
              style: TextStyle(
                color: darkBlue,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoTile(
    XFile image,
    int index,
  ) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(image.path),
            fit: BoxFit.cover,
          ),

          Positioned(
            right: 6,
            top: 6,
            child: GestureDetector(
              onTap: () =>
                  _removePhoto(index),
              child: Container(
                width: 27,
                height: 27,
                decoration:
                    const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: darkBlue,
                  size: 16,
                ),
              ),
            ),
          ),

          Positioned(
            left: 8,
            bottom: 7,
            child: Text(
              'Photo ${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VIDEO
  // ============================================================

  Widget _buildVideoSection() {
    if (selectedVideo != null) {
      return _buildSelectedVideo();
    }

    return GestureDetector(
      onTap: isPickingVideo
          ? null
          : _showVideoOptions,
      child: Container(
        width: double.infinity,
        height: 135,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration:
                  const BoxDecoration(
                color: softBlue,
                shape: BoxShape.circle,
              ),
              child: isPickingVideo
                  ? const Padding(
                      padding:
                          EdgeInsets.all(14),
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: primaryBlue,
                      ),
                    )
                  : const Icon(
                      Icons.videocam_outlined,
                      color: primaryBlue,
                      size: 27,
                    ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Add a video',
              style: TextStyle(
                color: darkBlue,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 3),

            const Text(
              'Gallery or camera',
              style: TextStyle(
                color: textGrey,
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedVideo() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: darkBlue,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.white,
                  size: 42,
                ),
                SizedBox(height: 5),
                Text(
                  'Video added',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: _removeVideo,
              child: Container(
                width: 28,
                height: 28,
                decoration:
                    const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: darkBlue,
                  size: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO
  // ============================================================

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: softBlue,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration:
                const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: primaryBlue,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload clear evidence',
                  style: TextStyle(
                    color: darkBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Clear photos or videos can help emergency teams assess the incident faster.',
                  style: TextStyle(
                    color: textGrey,
                    fontSize: 10.5,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NEXT BUTTON
  // ============================================================

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              'Continue to Review',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_rounded,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget _buildProgress() {
    return Row(
      children: [
        _buildProgressStep(
          number: '1',
          title: 'Details',
          active: true,
        ),

        Expanded(
          child: Container(
            height: 2,
            margin:
                const EdgeInsets.only(
              bottom: 18,
            ),
            color: primaryBlue,
          ),
        ),

        _buildProgressStep(
          number: '2',
          title: 'Upload',
          active: true,
        ),

        Expanded(
          child: Container(
            height: 2,
            margin:
                const EdgeInsets.only(
              bottom: 18,
            ),
            color: Colors.grey.shade300,
          ),
        ),

        _buildProgressStep(
          number: '3',
          title: 'Review',
          active: false,
        ),
      ],
    );
  }

  Widget _buildProgressStep({
    required String number,
    required String title,
    required bool active,
  }) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: active
                ? primaryBlue
                : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: active
                  ? primaryBlue
                  : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Center(
            child: active && number == '2'
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 18,
                  )
                : Text(
                    number,
                    style: TextStyle(
                      color: active
                          ? Colors.white
                          : textGrey,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          title,
          style: TextStyle(
            color: active
                ? primaryBlue
                : textGrey,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}