module ApplicationHelper
    def full_title(page_title = '')  # full_titleメソッドを定義
        base_title = 'NEXT公務員'
        if page_title.blank?
          base_title  # トップページはタイトル「NEXT公務員」
        else
          "#{page_title} - #{base_title}" # トップ以外のページはタイトル「利用規約 - さよなら公務員」（例）
        end
    end
end
