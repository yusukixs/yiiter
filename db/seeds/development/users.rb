names = %w(Taro Jiro Hana John Mike Sophy Bill Alex Mary Tom)
fnames = ["佐藤", "鈴木", "高橋", "田中"]
gnames = ["太郎", "次郎", "花子"]
0.upto(9) do |idx|
  user = User.create(
    account_name: names[idx],
    full_name: "#{fnames[idx % 4]} #{gnames[idx % 3]}",
    email: "#{names[idx]}@example.com",
    administrator: (idx == 0),
    password: "password",
    password_confirmation: "password"
  )
  path = Rails.root.join("db/seeds/development", "member#{idx % 3 + 1}.jpg")
  file = Rack::Test::UploadedFile.new(path, "image/jpeg", true)
  UserImage.create(
    user: user,
    uploaded_image: file
  ) 
end