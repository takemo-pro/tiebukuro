module UsersHelper
  def get_gravatar_img(user, size: 80)
    if user.user_icon.attached?#アイコンがアタッチされてたらそれを、されてなかったらgravatarを表示する。
      image_tag(user.resize_icon(size: size), alt: user.name, class: 'gravatar rounded-circle')
    else
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: 'gravatar rounded-circle')
    end

  end
end
