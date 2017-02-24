@test "creates the swap file" {
  test -f /mnt/swap
}

@test "has the correct size" {
  ls -l --block-size=M /mnt | grep "swap" | grep "1M"
}

@test "swappiness is set to 10" {
  grep 10 /proc/sys/vm/swappiness
}
