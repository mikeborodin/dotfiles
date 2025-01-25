#! env nu

let value = (git-cal | lines | get 12)

if (not ($value | str contains "0:")) {
  print $"🔥($value)"
} else {
  print "no streak"
}
