(defn processed-files
  "Provides access to the list of processed files in the 'map of the world' that
  gets passed to each layout."
  [data]
  (-> data :config :processed-files vals))

(defn mru
  "`mru` stands for most-recently-updated, but this function also can provide most recently published.
  this function requires that your files have a #+DATE_UPDATED and #+DATE_CREATED
  front matter."
  ;; `data` - map - the entire configuration map passed to all layouts must be passed here.
  ;; `num-to-show` - integer to determine how many recent files should be shown
  ;; `recently` - a keyword that can be `:updated` or `:published`.
  [data {:keys [num-to-show recently]
         :or   {recently :updated}}]
  ;; we determine the keyword to use so that we may sort our files.
  (let [date-type (case recently
                    :updated :date-updated-ts
                    :created :date-created-ts)
        ;; we use the helper fn defined above to get access too all files.
        files     (processed-files data)
        ;; now we use clojure's sorting mechanism to sort by the determined
        ;; date-updated/created ts (timestamp -- which is internally available
        ;; to firn.)
        by-date   (sort-by (fn [a]
                             ; get-in's nill fallback doesn't seem to work so I'm using `or`.
                             (or (get-in a [:meta date-type]) 0)) >  files)
        ]

    ;; Here is the hiccup/html that is renderering a list of links to the fecent files
    [:ul.list-style-none.p0
     (for [f    (take num-to-show by-date)
           :let [{:keys [title date-updated-ts date-created-ts]}(f :meta)]]
       (when (and title date-updated-ts date-created-ts)
         [:li.px2 [:a {:href (f :path-web)} title]]))]))
