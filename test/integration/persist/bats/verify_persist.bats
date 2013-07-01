@test "writes fstab" {
  cat /etc/fstab | grep /mnt/swap
}
