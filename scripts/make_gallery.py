"""Build documentation contact sheets from the original simulator PNGs.

Run with Python + Pillow: python3 scripts/make_gallery.py
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
SCREENSHOTS = ROOT / 'docs/screenshots'
FONT = ImageFont.truetype(str(ROOT / 'assets/fonts/IBMPlexSans-Medium.ttf'), 18)


def sheet(files, destination, width=280, columns=3):
    height = round(width * 2622 / 1206)
    gap, caption = 20, 44
    rows = (len(files) + columns - 1) // columns
    canvas = Image.new('RGB', (columns * (width + gap) + gap,
                              rows * (height + caption + gap) + gap), '#F5F5F8')
    drawing = ImageDraw.Draw(canvas)
    for index, path in enumerate(files):
        x = gap + index % columns * (width + gap)
        y = gap + index // columns * (height + caption + gap)
        drawing.text((x + 4, y + 6), path.stem.split('_', 1)[1].replace('_', ' ').title(),
                     font=FONT, fill='#27242D')
        with Image.open(path) as original:
            image = original.convert('RGB')
            image.thumbnail((width, height), Image.Resampling.LANCZOS)
            canvas.paste(image, (x, y + caption))
    canvas.save(destination, optimize=True)


if __name__ == '__main__':
    main_screens = ['05_feeds', '07_categories', '11_shop', '19_chats', '22_player', '23_balance']
    sheet([SCREENSHOTS / f'{name}.png' for name in main_screens], SCREENSHOTS / 'overview.png')
    files = sorted(SCREENSHOTS.glob('[0-9]*.png'))
    for offset in range(0, len(files), 9):
        sheet(files[offset:offset + 9], SCREENSHOTS / f'gallery_{offset // 9 + 1}.jpg', width=240)
