#!/bin/bash
set -eux

USER_NAME="$1"
USER_PASSWORD="$2"
USER_SSH_PUBLIC_KEY="$3"

if [ -z "${USER_NAME}" ]; then
  echo "Error: user name is not provided."
  exit 1
fi

if [ -z "${USER_PASSWORD}" ]; then
  echo "Error: user password is not provided."
  exit 1
fi

if [ -z "${USER_SSH_PUBLIC_KEY}" ]; then
  echo "Error: user SSH public key is not provided."
  exit 1
fi

echo ":: Creating user [${USER_NAME}]..."

# Create user.
sudo sysadminctl -addUser "${USER_NAME}" -password "${USER_PASSWORD}" --create-home

# Change shell to Bash.
chsh -s /bin/bash "${USER_NAME}"

# Switch to user directory.
pushd "/Users/${USER_NAME}"

# Configure SSH access.
SSH_DIR=".ssh"
SSH_KEYS_FILE="${SSH_DIR}"/authorized_keys

sudo mkdir -p "${SSH_DIR}"
sudo touch "${SSH_KEYS_FILE}"

chmod u+rw "${SSH_DIR}"
chmod u+rw "${SSH_KEYS_FILE}"
# sudo bash -c "${USER_SSH_PUBLIC_KEY}" > "${SSH_KEYS_FILE}"
echo "${USER_SSH_PUBLIC_KEY}" | sudo tee -a "${SSH_KEYS_FILE}"

# ATTENTION
# You can install required tools, packages and SDKs in this step.
# The following commented commands are an example of installing Android SDK.

ANDROID_SDK_FILE="android-sdk.zip"
ANDROID_SDK_DIR="android-sdk"

curl --location "https://dl.google.com/android/repository/platform-tools-latest-darwin.zip" --output "${ANDROID_SDK_FILE}"
unzip -q "${ANDROID_SDK_FILE}" -d "${ANDROID_SDK_DIR}"
rm "${ANDROID_SDK_FILE}"

mv .bashrc .bashrc_original
echo -e "export ANDROID_HOME=/home/${USER_NAME}/${ANDROID_SDK_DIR}\n" >> .bashrc
cat .bashrc_original >> .bashrc
rm .bashrc_original

# Change ownership to all affected files.
sudo chown -R "${USER_NAME}" "/Users/${USER_NAME}/"

echo ":: Created user [${USER_NAME}]!"

# Switch from user directory.
popd