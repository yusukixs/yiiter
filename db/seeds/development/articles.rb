description = 
  "## あいうえお¥n" +
  "- 箇条書き1¥n" +
  "  - 箇条書き2"

%w(Taro Jiro Hana).each do |name|
  user = User.find_by(account_name: name)
  0.upto(9) do |idx|
    Article.create(
      author: user,
      title: "記事#{idx}",
      description: description,
      released_at: 10.days.ago.advance(days: idx),
      status: %w(draft member_only public)[idx % 3]
    )
  end
end
