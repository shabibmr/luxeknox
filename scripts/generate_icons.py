"""Regenerate all app icons from logo/luxeknox_logo.png.

The logo is wide (~2.55:1), so it is scaled to a fraction of each square icon's
width and centred on a solid background. Existing icon files are overwritten
in place, keeping their current pixel sizes.

Usage (from repo root):  python scripts/generate_icons.py
Requires: pip install pillow
"""
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
APP = ROOT / "app"
LOGO = ROOT / "logo" / "luxeknox_logo.png"

BG = (255, 255, 255, 255)
FILL = 0.84           # logo width as a fraction of the icon width
FILL_MASKABLE = 0.66  # maskable icons must stay inside the ~80% safe circle
FILL_ICO = 0.92       # tiny sizes need every pixel

# Files that must not contain an alpha channel (App Store rejects it).
NO_ALPHA_DIRS = ("AppIcon.appiconset",)


def load_logo() -> Image.Image:
    img = Image.open(LOGO).convert("RGBA")
    return img.crop(img.getbbox())  # trim any transparent margin


def render(logo: Image.Image, size: int, fill: float) -> Image.Image:
    canvas = Image.new("RGBA", (size, size), BG)
    w = max(1, round(size * fill))
    h = max(1, round(w * logo.height / logo.width))
    resized = logo.resize((w, h), Image.LANCZOS)
    canvas.alpha_composite(resized, ((size - w) // 2, (size - h) // 2))
    return canvas


def save_png(path: Path, logo: Image.Image, fill: float) -> None:
    size = Image.open(path).size[0]
    img = render(logo, size, fill)
    if any(d in path.parts for d in NO_ALPHA_DIRS):
        img = img.convert("RGB")
    img.save(path)
    print(f"{path.relative_to(ROOT)}  {size}px")


def main() -> None:
    logo = load_logo()

    targets = []
    targets += (APP / "android/app/src/main/res").glob("mipmap-*/ic_launcher*.png")
    targets += (APP / "ios/Runner/Assets.xcassets/AppIcon.appiconset").glob("*.png")
    targets += (APP / "macos/Runner/Assets.xcassets/AppIcon.appiconset").glob("*.png")
    targets += [APP / "web/favicon.png"]
    targets += (APP / "web/icons").glob("Icon-*.png")

    for path in sorted(targets):
        fill = FILL_MASKABLE if "maskable" in path.name else FILL
        save_png(path, logo, fill)

    ico = APP / "windows/runner/resources/app_icon.ico"
    sizes = [16, 24, 32, 48, 64, 128, 256]
    render(logo, 256, FILL_ICO).save(ico, sizes=[(s, s) for s in sizes])
    print(f"{ico.relative_to(ROOT)}  {sizes}")


if __name__ == "__main__":
    main()
