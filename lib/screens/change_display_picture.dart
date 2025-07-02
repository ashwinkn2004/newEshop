import 'package:eshop/constants.dart';
import 'package:eshop/provider/avatar_provider.dart';
import 'package:eshop/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChangeDisplayPicture extends ConsumerWidget {
  const ChangeDisplayPicture({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarState = ref.watch(avatarProvider);
    final avatarNotifier = ref.read(avatarProvider.notifier);
    final userAsync = ref.watch(userInfoProvider);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      backgroundColor: Colors.white,
      body: userAsync.when(
        data: (user) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Change Your Avatar",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Avatar Circle
              GestureDetector(
                onTap: () => avatarNotifier.pickImage(context),
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: kSecondaryColor.withOpacity(0.1),
                  backgroundImage: avatarState.localImage != null
                      ? FileImage(avatarState.localImage!)
                      : (avatarState.networkUrl != null &&
                            avatarState.networkUrl!.isNotEmpty)
                      ? NetworkImage(avatarState.networkUrl!)
                      : null,
                  child:
                      (avatarState.localImage == null &&
                          (avatarState.networkUrl == null ||
                              avatarState.networkUrl!.isEmpty))
                      ? Text(
                          user['name']?.substring(0, 1).toUpperCase() ?? '?',
                          style: const TextStyle(
                            fontSize: 48,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 32),

              // Choose Picture
              buildPrimaryButton(
                label: "Choose Picture",
                icon: LucideIcons.image,
                onPressed: () => avatarNotifier.pickImage(context),
              ),
              const SizedBox(height: 12),

              // Upload Picture
              buildPrimaryButton(
                label: "Upload Picture",
                icon: LucideIcons.uploadCloud,
                onPressed: () => avatarNotifier.uploadImage(context),
              ),
              const SizedBox(height: 12),

              // Remove Picture
              buildRemoveButton(
                label: "Remove Picture",
                icon: LucideIcons.trash,
                onPressed: () => avatarNotifier.removeImage(context),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }

  Widget buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  Widget buildRemoveButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.red),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: Colors.red,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
