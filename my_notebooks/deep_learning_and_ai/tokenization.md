---
title: Tokenization
---

## How spaces are treated

## OpenAI's tokenizer

OpenAI uses the byte-pair encoding tokeniser  [`tiktoken`](https://github.com/openai/tiktoken) which is open-source.

You can compare OpenAI's tokenizers of different GPT versions here:

https://platform.openai.com/tokenizer

The first 256 tokens are exactly the 256 raw bytes that make up any character or UTF-8 sequence. This ensure that the tokenizer can process any piece of text, code, or unknown binary symbol.

Starting at token ID 256, `tiktoken` starts mapping common text patterns and merge byte structures compiled by the Byte Pair Encoding (BPE) training process, e.g.:

- merged spaces like three spaces or double line breaks `\n\n`
- common words: core English structures like `the`, `to`, `and` or `ing`

### Differen token ID's for the same word

In tiktoken (and almost all Byte Pair Encoding tokenizers used by OpenAI),
a word at the start of a line is treated as a completely different token
than the same word mid-line.

Tokenizers are trained to group the space before a word together with the word itself.

```python
import tiktoken

enc = tiktoken.get_encoding("cl100k_base")

# Case 1: Start of text (no leading space)
print(enc.encode("test"))   
# Output: [4259]

# Case 2: Mid-line text (with leading space)
print(enc.encode(" test"))  
# Output: [1344]
```

Binding spaces to the front of words saves massive amounts of context window space. If spaces and words were kept separate, every single word in a sentence would require two tokens (one for the space, one for the word). By merging them into tokens like " test", " the", and " and", the model effectively cuts the token cost of normal text in half.

### Natural languages

If you filter out shared words, the first whole tokens that are 100% exclusively German start appearing roughly in the late 1,000s and early 2,000s, where high-frequency German grammar particles are isolated from English contexts.

