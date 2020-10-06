# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Faker::Config.locale = :ja
#ユーザーの生成
User.create!(name: 'take',
             email: 'take.webengineer@gmail.com',
             password: 'foobar',
             password_confirmation: 'foobar',
             activated: true,
             admin: true)
#ユーザーのフォロー
users=User.all
user1 = user.first
following = users[2..50]
followers = users[3..30]
following.each {|followed| user1.follow(followed)}
followers.each {|follower| follower.follow(user1)}

99.times do |n|
  name = Faker::Name.name
  email = "fake-#{n}@email.com"
  password = 'password'
  profile = Faker::Lorem.sentence(word_count: 15)
  User.create!(name: name, email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               profile: profile)
end

#questionの生成
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  title = Faker::Lorem.sentence(word_count: 2)
  users.each {|user| user.questions.create!(content: content,title: title)}
end

#commentの生成
questions = Question.order(:created_at).take(10) #Questionを作成順に１０個取り出す
questions.each do |question| #各Questionに対して
  content = Faker::Lorem.sentence(word_count:3)
  #questionに結びついたコメントを作成し、coに代入する
  co = question.comments.create!(content: content, user: User.first)
  #coに結びついたコメントを作成する
  co.replies.create!(content: content, user: User.first, question: question)
end
