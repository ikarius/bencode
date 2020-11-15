(import ../bencode)

(comment
  # See:
  # https://github.com/janet-lang/janet/blob/a68ee7aac68ac8a1a993cbcedbb2125c9e855e65/test/suite3.janet#L365

  (peg/match peg-decode "i-7654321e")
  (peg/match peg-decode "i1234567e")
  (peg/match peg-decode "i1234ei5678e")
  (peg/match peg-decode "4:abcd")
  (peg/match peg-decode "4:abcd4:efgh")
  (peg/match peg-decode "4:abcdeee")
  (peg/match peg-decode "4:abcdi1234e")
  (peg/match peg-decode "0:")
  (peg/match peg-decode "li3453453ei8232434ei-3434ee")
  (peg/match peg-decode "li4343ee")
  (peg/match peg-decode "l4:abcd4:efghe")
  (peg/match peg-decode "l4:abcdx4:efghe")
  (peg/match peg-decode "le")
  (peg/match peg-decode "d4:spaml1:a1:bee")
)

(comment
  (encode 12345)
  (encode "Hello World!")
  (encode [1 2 3])
  (encode {:a 1 :b 2 "c" 3})
  (encode {:test-key [123567890 "Hello" [1 2 "a string"]]})
  (decode "d8:test-keyli123567890e5:Helloli1ei2e8:a stringeee")

  (-> [123 "a string" [1 2 "3"]]
      (encode)
      (decode))

  (decode "d4:testli123e4:fredli1ei2e1:3eee")
  (decode "d1:ci3e1:ai1e1:bi2ee")
  (decode "d1:ai1ee")
)

