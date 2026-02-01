# Colors of Seoul (서울의 색)

This document is designed to showcase the **Seoul Theme** palette. Open this file and switch between the themes (*Seoul Night*, *Seoul Dancheong*, *Seoul Morning*) to see how the colors adapt.

---

## 1. Seoul Dancheong (단청)
> *Vivid, Artistic, and Structural.*

The **Dancheong** theme draws from the intricate decorative coloring on traditional wooden architecture. It uses high contrast for clarity.

```python
# 🏵️ The Concept: The vivid colors of the Palace
class Dancheong:
    def __init__(self):
        self.roof = "Giwa (Grey-Green)"      # UI Background
        self.pattern = "O-bang-saek"         # Vivid Accents

    def paint_architecture(self):
        """
        Red (Jeok) for keywords/flow.
        Blue (Cheong) for functions/logic.
        Green (Nok) for strings/values.
        """
        keyword = "Passionate Red"
        logic = "Cool Blue"
        value = "Natural Green"
        
        return [keyword, logic, value]
```

---

## 2. Seoul Morning (서울의 아침)
> *Clean, Airy, and Natural.*

The **Morning** theme mimics sunlight filtering through **Hanji** (traditional paper). It uses off-white and soft grays instead of harsh brightness.

```go
// ☀️ The Concept: Sunlight on Hanji Paper
package main

import "fmt"

func main() {
	// Background: Yubaesaek (Rice/Milk White) - No glare
	// Text: Giwajinhoesaek (Dark Ink Grey) - Sharp like ink

	morningVibe := map[string]string{
		"Sky":   "Clear",
		"Paper": "Warm",
		"Ink":   "Distinct",
	}

	if morningVibe["Sky"] == "Clear" {
		fmt.Println("Start your day with clarity.")
	}
}
```

---

## 3. Seoul Night (서울의 밤)
> *Quiet, Deep, and Comfortable.*

The **Night** theme captures the stillness of Seoul after dark. It avoids pure black, using deep charcoal and warm earthy tones to reduce eye strain.

```typescript
// 🌙 The Concept: A walk along the Han River
interface NightMood {
  background: 'Heukbaek (Deep Charcoal)';  // Soft on the eyes
  text: 'Sosaek (Warm Beige)';            // Readable contrast
  point: 'Jangdansaek (Soft Red)';        // Subtle highlights
}

function enjoyTheNight(): void {
  const mood = "Calm";
  const stars = ["Soft", "Warm", "Quiet"];
  
  // This comment is subtle, like a whisper in the night.
  console.log(`Feeling ${mood} with ${stars.length} stars.`);
}
```

---

## 🎨 Color Palette Reference

| Color Name | Hex Code | Role |
|:---|:---:|:---|
| **Heukbaek** (Dark Charcoal) | `#2c2c2c` | Night Background |
| **Sosaek** (Warm Beige) | `#f5f5dc` | Night/General Text |
| **Dancheong Red** | `#c13636` | Keywords (Dancheong) |
| **Dancheong Blue** | `#365ec1` | Functions (Dancheong) |
| **Dancheong Green** | `#36c16e` | Strings (Dancheong) |
| **Yubaesaek** (Rice White) | `#fcfbf9` | Morning Background |
| **Giwa** (Roof Tile Grey) | `#4a5a6a` | UI Elements |
