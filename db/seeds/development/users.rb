names = %w(Taro Jiro Hana John Mike Sophy Bill Alex Mary Tom)
fnames = ["佐藤", "鈴木", "高橋", "田中"]
gnames = ["太郎", "次郎", "花子"]
0.upto(99) do |idx|
  User.create(
    account_name: names[idx % 9],
    full_name: "#{fnames[idx % 4]} #{gnames[idx % 3]}",
    email: "#{names[idx % 9]}@example.com",
    administrator: (idx == 0),
    password: "password",
    password_confirmation: "password"
  )
end