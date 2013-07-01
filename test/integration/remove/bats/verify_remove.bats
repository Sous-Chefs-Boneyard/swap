@test "removes the swapfile" {
  test ! -e /mnt/swap
}
