@test "creates the swap file" {
  test -f /mnt/swap
}

@test "has the correct size" {
  ls -l --block-size=M /mnt | grep "swap" | grep "1M"
}
