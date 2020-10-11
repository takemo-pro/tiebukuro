module HomePagesHelper
  def sort_select_button_text
    case params[:sort]
    when nil then
      text = "新規投稿順"
    when "likes" then
      text = "いいねが多い順"
    when "follow" then
      text = "フォロー中の質問"
    when "nonsolved" then
      text = "未解決の質問"
    end

  end
end
