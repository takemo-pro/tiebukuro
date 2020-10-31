module HomePagesHelper
  def sort_select_button_text
    case params[:sort]
    when "likes" then
      text = "いいねが多い順の質問"
    when "follow" then
      text = "フォロー中の質問"
    when "nonsolved" then
      text = "未解決の質問"
    else
      unless params[:tag_name].nil?
        text = "「#{params[:tag_name]}」タグの投稿"
      else
        text = "新規投稿順の投稿"
      end
    end

  end
end
