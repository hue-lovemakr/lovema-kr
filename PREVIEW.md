# Colors of Seoul (서울의 색)

This document is designed to showcase the **Seoul Theme** palette. Open this file and switch between the themes (*Seoul Night*, *Seoul Dancheong*, *Seoul Morning*) to see how the colors adapt.

---

## 1. Seoul Dancheong (단청)
> *Vivid, Artistic, and Structural.*

The **Dancheong** theme draws from the intricate decorative coloring on traditional wooden architecture. A dark editor and brighter green-grey surrounding surfaces create a structural two-tone layout.

```python
# 🏵️ The Concept: The vivid colors of the Palace
class Dancheong:
    def __init__(self):
        self.roof = "Giwa (Grey-Green)"      # UI Background
        self.pattern = "O-bang-saek"         # Vivid Accents

    def paint_architecture(self):
        """
        Damju red for keywords and control flow.
        Seoul sky blue for functions, properties, and logic.
        Jahwang yellow for strings and jade green for types.
        """
        keyword = "Passionate Red"
        logic = "Cool Blue"
        value = "Warm Jahwang Yellow"
        
        return [keyword, logic, value]
```

---

## 2. Seoul Morning (서울의 아침)
> *Clean, Airy, and Natural.*

The **Morning** theme mimics sunlight filtering through **Hanji** (traditional paper). It uses near-white and warm neutral surfaces with green-grey ink instead of pure black text.

```go
// ☀️ The Concept: Sunlight on Hanji Paper
package main

import "fmt"

func main() {
	// Background: a Yubaesaek-derived paper neutral
	// Text: Giwajinhoesaek-derived green-grey ink

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

The **Night** theme captures the stillness of Seoul after dark. It avoids pure black for large surfaces and uses warm foregrounds with restrained color accents.

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
| **Heukbaek** (흑백) | `#1d1e23` | Night background |
| **Sosaek** (소색) | `#d8c8b2` | Warm primary editor text |
| **Jangdansaek** (장단색) | `#e16350` | Night keywords and accents |
| **Damjusaek** (담주색) | `#ea8474` | Dancheong keywords and control flow |
| **Dancheong Red** (단청빨간색) | `#c4003b` | Dancheong focus and status accents |
| **Seoul Sky Blue** (서울하늘색) | `#5eb3ff` | Dancheong functions, properties, and links |
| **Jahwangsaek** (자황색) | `#f7b938` | Dancheong strings and highlighted values |
| **Namsan Green** (남산초록색) | `#237a4e` | Selection, Git additions, and green accents |
| **Giwajinhoesaek** (기와진회색) | `#405349` | Source for green-grey UI surfaces |
| **Yubaesaek** (유배색) | `#e7e6d2` | Source for Morning paper-like UI neutrals |

The themes also use derived neutral shades, brighter readability variants, and alpha overlays while preserving the natural harmony of traditional Korean colors.
