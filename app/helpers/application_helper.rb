module ApplicationHelper
  #基本タイトルか基本タイトルにサブタイトルをつけたものを返します。
  def set_full_title(page_title = '')
    base_title = 'Knowte'
    if page_title.empty?
      provide(:title, base_title)
    elsif provide(:title, page_title + ' / ' + base_title)
    end
  end
end
