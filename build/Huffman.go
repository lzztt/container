package main

import (
	"fmt"
	"golang.org/x/net/http2/hpack"
)

func main() {
	fmt.Println("Encode:")
	fmt.Println("nginx", "→", Encode("nginx"))
	fmt.Println("lzx", "→", Encode("lzx"))
	fmt.Println("Decode:")
	fmt.Println("\\x84\\xaa\\x63\\x55\\xe7", "→", Decode("\x84\xaa\x63\x55\xe7"))
	fmt.Println("\\x83\\xa3\\xdf\\x9f", "→", Decode("\x83\xa3\xdf\x9f"))
}

func Encode(s string) string {
	var result string

	hd := hpack.AppendHuffmanString(nil, s)
	hl := hpack.HuffmanEncodeLength(s) | 0x80

	result += RenderByte(byte(hl))

	for _, b := range hd {
		result += RenderByte(b)
	}

	return result
}

func Decode(s string) string {
	data := []byte(s)
	result, _ := hpack.HuffmanDecodeToString(data[1:])
	return result
}

func RenderByte(b byte) string {
	return fmt.Sprintf("\\x%x", b)
}
