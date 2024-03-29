(use joy)
(import /raspberry)


# Layout
(defn app-layout [{:body body :request request}]
  (text/html
    (doctype :html5)
    [:html {:lang "en"}
     [:head
      [:title "raspystatus"]
      [:meta {:charset "utf-8"}]
      [:meta {:name "viewport" :content "width=device-width, initial-scale=1"}]
      [:meta {:name "csrf-token" :content (csrf-token-value request)}]
      [:link {:href "/app.css" :rel "stylesheet"}]
      [:script {:src "/app.js" :defer ""}]]
     [:body
       body]]))


# Routes
(route :get "/" :home)
(route :get "/stats" :stats)

(defn home [request]
  [:div {:class "tc"}
   [:h1 "You found home"]
   [:p {:class "code"}
    [:b "Temprature: "]
    [:span (raspberry/get_tmp)]]
   [:p {:class "code"}
    [:b "Janet Version:"]
    [:span janet/version]]])

(defn stats [request]
  (application/json {:tmp (raspberry/get_tmp)}))


# Middleware
(def app (-> (handler)
             (layout app-layout)
             (with-csrf-token)
             (with-session)
             (extra-methods)
             (query-string)
             (body-parser)
             (json-body-parser)
             (server-error)
             (x-headers)
             (static-files)
             (not-found)
             (logger)))


# Server
(defn main [& args]
  (let [port (get args 1 (os/getenv "PORT" "9001"))
        host (get args 2 "localhost")]
    (do
      (print "Running on " port)
      (server app port host))))
