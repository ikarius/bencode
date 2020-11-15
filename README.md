# bencode

A minimal Janet bencode library.

## Installation

Add a dependency in your `project.janet` file:

```
(declare-project
    ...
    :dependencies ["https://github.com/ikarius/bencode"]
    ...
)
```

## Usage

bencode uses PEG for decoding and a naive recusive implementation for encoding.

```
(import bencode)

(bencode/encode {:test-key [123567890 "Hello" [1 2 "a string"]]})
=> "d8:test-keyli123567890e5:Helloli1ei2e8:a stringeee"

(bencode/decode "d8:test-keyli123567890e5:Helloli1ei2e8:a stringeee")
=> {"test-key" @[123567890 "Hello" @[1 2 "a string"]]}  

```

## Licence

bencode is licenced under the MIT Licence. See [LICENCE](LICENCE) for details.
