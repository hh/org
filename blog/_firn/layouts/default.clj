(defn default
  [{:keys [render partials] :as config}]
  (let [{:keys [head mru]} partials]
    [:html
     (head config)
     [:body
      [:main
       [:article.content
        ;; [:div (render :toc)] ;; Optional; add a table of contents
        [:div (render :file)]]
       (mru config {:num-to-show 5 :recently :updated})
       ]]]))
