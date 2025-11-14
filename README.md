# Igor's Dotfiles

Managed using stow

## SSH Key Management

### Adding a New SSH Key to macOS Keychain

With `UseKeychain yes` enabled, SSH keys are **automatically** added to the macOS Keychain when first used:

```bash
# Method 1: Automatic (recommended)
# Just use your new key - it will be automatically added to Keychain on first use
ssh -T git@github.com  # or wherever you're using the new key

# Method 2: Manual (if you prefer explicit control)
ssh-add --apple-use-keychain ~/.ssh/your-new-key-name

# Verify it was added:
ssh-add -l
```

### Removing an SSH Key

To remove an SSH key from your setup:

```bash
# Remove from current session:
ssh-add -d ~/.ssh/your-key-name

# Remove ALL keys from current session:
ssh-add -D

# Remove from macOS Keychain permanently:
ssh-add -K -d ~/.ssh/your-key-name

# Or use Keychain Access app:
# Applications > Utilities > Keychain Access
# Search for your key name and delete it
```

**Note**: Keys removed with `ssh-add -d` are only removed from the current session. To permanently remove from macOS Keychain, use `ssh-add -K -d` or the Keychain Access app.

### SSH Configuration

The SSH config automatically handles:
- Adding keys to the ssh-agent (`AddKeysToAgent yes`)
- Storing keys in macOS Keychain (`UseKeychain yes`)
- Cross-compatibility with Homebrew SSH (`IgnoreUnknown UseKeychain`)
- Using only specified identity files (`IdentitiesOnly yes`)
- Per-host key selection

