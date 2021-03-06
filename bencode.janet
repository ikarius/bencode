### Bencode
### https://wiki.theory.org/BitTorrentSpecification#Bencoding

(def- ascii-chars (string/from-bytes ;(range 256)))
(def- end-sep "e")

(def- peg-decode (peg/compile 
                   ~{:ascii (set ,ascii-chars)
                     :sep end-sep
                     :integer (* "i" (cmt (<- (* (? "-") :d+)) ,parse) :sep)
                     :string (cmt (* (/ (<- :d+) ,parse :1) ":" (<- (lenprefix (-> :1) :ascii))) ,|$1)
                     :list (group (* "l" (any (+ :data)) :sep))
                     :table (* "d" (replace (any (* :string :data)) ,struct))
                     :data (+ :list :table :integer :string)
                     :main (any :data) }))

(defn decode 
  "
  Decode a bencode string 
  
  If strict? is false, decode will try to eval as much of the input as possible.
  Otherwise an error is thrown at the first parsing issue encountered.
  "
  [input &keys strict?]
  (default strict? true)
  (let [[result rest] (peg/match peg-decode input)]
    (if (or (and strict? rest) (nil? result))
      (error (string "Invalid input, rest should be none but is: " rest))
      result))) 

(defn encode 
  "
  Encode an object to bencode

  Naively recursive, but should do with rather large structures.
  If any issue, walk fns can be used instead of recursion.
  "
  [o &keys strict?]
  (default strict? true)
  (def buf @"")
  
  (defn- encode-string [s]
    (assert (find |(= $ (type s)) [:string :buffer :keyword]))
    (buffer/push-string buf (string (length s) ":" s)))

  (defn- encode-integer [i]
    (assert (= (type i) :number))
    (buffer/push-string buf (string "i" (int/s64 i) end-sep)))

  (defn- encode-list [l]
    (assert (find |(= $ (type l)) [:array :tuple]))
    (buffer/push-string buf "l")  
    (each v l
        (buffer/push-string buf (encode v)))
    (buffer/push-string buf end-sep))

  (defn- encode-table [t]
    (assert (find |(= $ (type t)) [:struct :table]))
    (buffer/push-string buf "d")  
    (eachp [k v] t
      (when strict?
        (assert (or (= :keyword (type k)) (= :string (type k)))))
      (buffer/push-string buf (encode (string k)))
      (buffer/push-string buf (encode v)))
    (buffer/push-string buf end-sep))

  (let [current-type (type o)]
    (case current-type 
      :tuple   (encode-list o)
      :array   (encode-list o)
      :number  (encode-integer o)
      :string  (encode-string o)
      :keyword (encode-string o)
      :buffer  (encode-string o)
      :struct  (encode-table o)
      :table   (encode-table o)
      (when strict?
        (error (string "Unknown bencode type: " current-type)))))

  (string buf))
