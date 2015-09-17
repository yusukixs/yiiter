text = "
* リスト1
  * リスト1-1(入れ子もOK)
  * リスト1-2(入れ子もOK)
* リスト2

1. 数字リスト1
  1. 数字リスト1-1(入れ子もOK)
  1. 数字リスト1-2(入れ子もOK)
1. 数字リスト2

## Rubyコード

~~~ ruby
test = [ 10, 20 ]
test.each do |v|
  puts v
end
~~~
"

%w(Taro Jiro Hana).each do |name|
  user = User.find_by(account_name: name)
  0.upto(9) do |idx|
    article= Article.create(
      author: user,
      title: "記事#{idx}",
      description: text,
      released_at: 10.days.ago.advance(days: idx),
      status: %w(draft member_only public)[idx % 3]
    )
    if idx == 7 || idx == 8
      %w(John Mike Sophy).each do |name2|
        voter = User.find_by(account_name: name2)
        voter.voted_articles << article
      end
    end
    if idx == 4 || idx == 8
      %w(John Mike Sophy).each do |name3|
        commenter = User.find_by(account_name: name3)
        Comment.create(
          user: commenter,
          article: article,
          comment: "引用1

> > 引用2 (入れ子にも対応)

> 引用3  
> 引用元: <cite>さかなチキンぱん。</cite>"
        ) 
      end
    end
  end
end
