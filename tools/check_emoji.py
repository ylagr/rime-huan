import sys
from pathlib import Path


def check_emoji_file(file_path: Path) -> list[str]:
    errors: list[str] = []
    seen_keys: dict[str, int] = {}

    with open(file_path, "r", encoding="utf-8") as f:
        for line_no, raw_line in enumerate(f, start=1):
            line = raw_line.rstrip("\r\n")
            if not line:
                errors.append(f"Line {line_no}: Empty line is not allowed.")
                continue

            # (3) 每行只有一個 tab
            tab_count = line.count("\t")
            if tab_count != 1:
                errors.append(
                    f"Line {line_no}: Expected exactly 1 tab, but found {tab_count}: {line!r}"
                )
                continue

            col1, col2 = line.split("\t")

            # (1) 第一列不重複
            if col1 in seen_keys:
                errors.append(
                    f"Line {line_no}: Duplicate key {col1!r} (previously seen at line {seen_keys[col1]})."
                )
            else:
                seen_keys[col1] = line_no

            # (2) 第一列和第二列（空格之前）的文字必須相同
            col2_prefix = col2.split(" ", 1)[0]
            if col1 != col2_prefix:
                errors.append(
                    f"Line {line_no}: Key {col1!r} does not match second column prefix {col2_prefix!r} (full: {col2!r})."
                )

    return errors


def main() -> None:
    if len(sys.argv) > 1:
        target_path = Path(sys.argv[1])
    else:
        target_path = Path(__file__).resolve().parent.parent / "opencc" / "moran_emoji.txt"

    if not target_path.exists():
        print(f"[ERROR] File not found: {target_path}", file=sys.stderr)
        sys.exit(1)

    errors = check_emoji_file(target_path)
    if errors:
        for err in errors:
            print(f"[ERROR] {err}", file=sys.stderr)
        print(f"[FAILED] Found {len(errors)} error(s) in {target_path}", file=sys.stderr)
        sys.exit(1)
    else:
        print(f"[OK] {target_path} passed all checks.")


if __name__ == "__main__":
    main()
