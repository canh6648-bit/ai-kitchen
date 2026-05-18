from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from collections import Counter
from PIL import Image
from ultralytics import YOLO
from google import genai
import mysql.connector
import os, io, json, unicodedata
from datetime import date, timedelta

app = FastAPI(title="AI Kitchen Pro")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# =========================
# CONFIG
# =========================
db_config = {
    "host": os.getenv("DB_HOST"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_NAME"),
    "port": int(os.getenv("DB_PORT")),
}

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
gemini_client = genai.Client(api_key=GEMINI_API_KEY)

# Nếu chưa có best.pt thì backend vẫn chạy, chỉ API quét ảnh báo lỗi rõ ràng.
model = None
try:
    if os.path.exists("best.pt"):
        model = YOLO("best.pt")
except Exception as e:
    print("Không load được YOLO best.pt:", e)

# Map nhãn YOLO / tên nhập tay về đúng tên tiếng Việt trong database.
# Chú ý: hàm canonical_name bên dưới xử lý cả chữ hoa/thường, dấu, gạch dưới.
translate_dict = {
    "Banh_Mi": "Bánh mì", "banh_mi": "Bánh mì",
    "Bi_Do": "Bí đỏ", "bi_do": "Bí đỏ",
    "Ca_Chep": "Cá chép", "ca_chep": "Cá chép",
    "Ca_Chua": "Cà chua", "ca_chua": "Cà chua", "tomato": "Cà chua",
    "Ca_Ro_Phi": "Cá rô phi", "ca_ro_phi": "Cá rô phi",
    "Ca_Rot": "Cà rốt", "ca_rot": "Cà rốt", "carrot": "Cà rốt",
    "Ca_Tim": "Cà tím", "ca_tim": "Cà tím",
    "Cai_Thao": "Cải thảo", "cai_thao": "Cải thảo",
    "Chanh": "Chanh", "chanh": "Chanh",
    "Chuoi": "Chuối", "chuoi": "Chuối", "banana": "Chuối",
    "Dau_Phu": "Đậu phụ", "dau_phu": "Đậu phụ",
    "Dau_Que": "Đậu que", "dau_que": "Đậu que",
    "Dua_Chuot": "Dưa chuột", "dua_chuot": "Dưa chuột",
    "Dua_Hau": "Dưa hấu", "dua_hau": "Dưa hấu",
    "Hanh_La": "Hành lá", "hanh_la": "Hành lá",
    "Hanh_Tay": "Hành tây", "hanh_tay": "Hành tây",
    "Khoai_Tay": "Khoai tây", "khoai_tay": "Khoai tây",
    "Muop_Dang": "Mướp đắng", "muop_dang": "Mướp đắng",
    "Ngao": "Ngao", "ngao": "Ngao",
    "Ot_Chuong": "Ớt chuông", "ot_chuong": "Ớt chuông",
    "Ot_Nho": "Ớt nhỏ", "ot_nho": "Ớt nhỏ",
    "Qua_Dua": "Quả dứa", "qua_dua": "Quả dứa",
    "Rau_Muong": "Rau muống", "rau_muong": "Rau muống",
    "Su_Hao": "Su hào", "su_hao": "Su hào",
    "Suon_Non": "Sườn non", "suon_non": "Sườn non",
    "Sup_Lo": "Súp lơ", "sup_lo": "Súp lơ", "broccoli": "Súp lơ",
    "Thit_Ga": "Thịt gà", "thit_ga": "Thịt gà", "chicken": "Thịt gà",
    "Thit_Lon": "Thịt lợn", "thit_lon": "Thịt lợn", "pork": "Thịt lợn",
    "Thit_Bo": "Thịt bò", "thit_bo": "Thịt bò", "beef": "Thịt bò",
    "Toi": "Tỏi", "toi": "Tỏi", "garlic": "Tỏi",
    "Tom": "Tôm", "tom": "Tôm", "shrimp": "Tôm",
    "Trung": "Trứng gà", "trung": "Trứng gà", "egg": "Trứng gà",
    "Xoai": "Xoài", "xoai": "Xoài",
    "qua_tao": "Quả táo", "apple": "Quả táo", "orange": "Quả cam", "ginger": "Gừng",
}

unit_dict = {
    "Bánh mì": "ổ", "Bí đỏ": "quả", "Cá chép": "con", "Cá rô phi": "con",
    "Quả táo": "quả", "Quả chuối": "quả", "Chuối": "quả", "Quả cam": "quả",
    "Trứng gà": "quả", "Cà chua": "quả", "Cà rốt": "củ", "Cà tím": "quả",
    "Cải thảo": "cây", "Chanh": "quả", "Đậu phụ": "bìa", "Đậu que": "g",
    "Dưa chuột": "quả", "Dưa hấu": "quả", "Hành lá": "nhánh", "Hành tây": "củ",
    "Khoai tây": "củ", "Mướp đắng": "quả", "Ngao": "g", "Ớt chuông": "quả",
    "Ớt nhỏ": "quả", "Quả dứa": "quả", "Rau muống": "bó", "Su hào": "củ",
    "Sườn non": "g", "Súp lơ": "cây", "Tỏi": "củ", "Gừng": "củ",
    "Nấm kim châm": "túi", "Tôm": "con", "Tôm tươi": "con",
    "Thịt bò": "g", "Thịt gà": "g", "Ức gà": "g", "Thịt lợn": "g", "Xoài": "quả"
}

def _key_name(name: str) -> str:
    """Tạo khóa so khớp không dấu, không phân biệt hoa/thường/gạch dưới."""
    name = (name or "").strip().replace("_", " ").replace("-", " ")
    name = unicodedata.normalize("NFD", name)
    name = "".join(ch for ch in name if unicodedata.category(ch) != "Mn")
    name = name.lower().replace("đ", "d")
    return " ".join(name.split())

_alias_pairs = {
    # YOLO labels
    "Banh_Mi": "Bánh mì", "Bi_Do": "Bí đỏ", "Ca_Chep": "Cá chép", "Ca_Chua": "Cà chua",
    "Ca_Ro_Phi": "Cá rô phi", "Ca_Rot": "Cà rốt", "Ca_Tim": "Cà tím", "Cai_Thao": "Cải thảo",
    "Chanh": "Chanh", "Chuoi": "Chuối", "Dau_Phu": "Đậu phụ", "Dau_Que": "Đậu que",
    "Dua_Chuot": "Dưa chuột", "Dua_Hau": "Dưa hấu", "Hanh_La": "Hành lá", "Hanh_Tay": "Hành tây",
    "Khoai_Tay": "Khoai tây", "Muop_Dang": "Mướp đắng", "Ngao": "Ngao", "Ot_Chuong": "Ớt chuông",
    "Ot_Nho": "Ớt nhỏ", "Qua_Dua": "Quả dứa", "Rau_Muong": "Rau muống", "Su_Hao": "Su hào",
    "Suon_Non": "Sườn non", "Sup_Lo": "Súp lơ", "Thit_Ga": "Thịt gà", "Thit_Lon": "Thịt lợn",
    "Toi": "Tỏi", "Tom": "Tôm", "Trung": "Trứng gà", "Xoai": "Xoài",
    # Tên người dùng hay nhập
    "trung ga": "Trứng gà", "trung": "Trứng gà", "ca chua": "Cà chua", "ca rot": "Cà rốt",
    "thit lon": "Thịt lợn", "thit heo": "Thịt lợn", "ga": "Thịt gà", "thit ga": "Thịt gà",
    "tom tuoi": "Tôm", "tom": "Tôm", "sup lo": "Súp lơ", "su hao": "Su hào", "hanh la": "Hành lá",
}

alias_dict = {_key_name(k): v for k, v in _alias_pairs.items()}

def canonical_name(name: str) -> str:
    """Chuẩn hóa tên nguyên liệu về đúng tên trong database."""
    if not name:
        return ""
    name = translate_dict.get(name, name)
    return alias_dict.get(_key_name(name), name.strip())

# =========================
# DATABASE
# =========================
def get_db_connection():
    try:
        return mysql.connector.connect(**db_config)
    except mysql.connector.Error as err:
        print("Lỗi kết nối Database:", err)
        return None

def fetch_all(query, params=()):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Không thể kết nối Database")
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute(query, params)
        return cursor.fetchall()
    finally:
        cursor.close(); conn.close()

def execute(query, params=()):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Không thể kết nối Database")
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute(query, params)
        conn.commit()
        return cursor.lastrowid
    finally:
        cursor.close(); conn.close()

# =========================
# MODELS
# =========================
class UserAuth(BaseModel):
    username: str
    password: str
    fullname: Optional[str] = None

class IngredientItem(BaseModel):
    name: str
    count: float = 1
    unit: str = "cái"

class IngredientRequest(BaseModel):
    ingredients: List[IngredientItem]
    servings: int = 2

class HistoryCreate(BaseModel):
    user_id: int
    recipe_name: str
    ingredients_used: str
    source: str
    instructions: str = ""
    image_url: str = ""
    match_score: Optional[int] = None
    missing_ingredients: str = ""
    alternatives: str = ""
    note: str = ""

class FavoriteCreate(BaseModel):
    user_id: int
    recipe_name: str
    ingredients_used: str = ""
    source: str = "favorite"
    instructions: str = ""
    image_url: str = ""
    match_score: Optional[int] = None
    missing_ingredients: str = ""
    alternatives: str = ""
    note: str = ""

# =========================
# HELPERS
# =========================
def ingredients_to_text(ingredients: List[IngredientItem]) -> str:
    return "\n".join([f"- {canonical_name(i.name)}: {i.count:g} {i.unit}" for i in ingredients])

def clean_gemini_json(raw_text: str) -> dict:
    raw_text = raw_text.strip().replace("```json", "").replace("```", "").strip()
    start = raw_text.find("{")
    end = raw_text.rfind("}")
    if start != -1 and end != -1:
        raw_text = raw_text[start:end+1]
    return json.loads(raw_text)

def normalize_ai_recipe(data: dict, source_default="gemini_ai") -> dict:
    data.setdefault("name", "Món ăn gợi ý")
    data.setdefault("instructions", "Chưa có hướng dẫn chi tiết.")
    data.setdefault("image_url", "https://via.placeholder.com/600x400?text=AI+Kitchen")
    data.setdefault("note", "")
    data.setdefault("source", source_default)
    data.setdefault("match_score", 80)
    data.setdefault("missing_ingredients", [])
    data.setdefault("alternatives", [])
    if not isinstance(data.get("missing_ingredients"), list):
        data["missing_ingredients"] = [str(data["missing_ingredients"])] if data["missing_ingredients"] else []
    if not isinstance(data.get("alternatives"), list):
        data["alternatives"] = [str(data["alternatives"])] if data["alternatives"] else []
    try:
        data["match_score"] = max(0, min(100, int(data.get("match_score", 80))))
    except Exception:
        data["match_score"] = 80
    return data

def get_recipe_ingredients(recipe_id: int):
    return fetch_all("""
        SELECT i.name, ri.quantity_desc, ri.is_main
        FROM recipe_ingredients ri
        JOIN ingredients i ON ri.ingredient_id = i.id
        WHERE ri.recipe_id = %s
        ORDER BY ri.is_main DESC, i.name ASC
    """, (recipe_id,))


def _name_set(ingredients: List[IngredientItem]) -> set:
    return {_key_name(canonical_name(i.name)) for i in ingredients if i.name}

def analyze_database_recipe(recipe: dict, user_ingredients: List[IngredientItem]) -> dict:
    """Gắn thông tin thiếu nguyên liệu cho 1 món database."""
    user_names = _name_set(user_ingredients)
    recipe_ings = get_recipe_ingredients(recipe["id"])

    main_missing = []
    optional_missing = []
    matched = []

    for ing in recipe_ings:
        ing_name = ing["name"]
        if _key_name(canonical_name(ing_name)) in user_names:
            matched.append(ing_name)
        else:
            if int(ing.get("is_main") or 0) == 1:
                main_missing.append(ing_name)
            else:
                optional_missing.append(ing_name)

    score = 100 - len(main_missing) * 25 - len(optional_missing) * 8
    score = max(35, min(100, score))

    analyzed = dict(recipe)
    analyzed["recipe_ingredients"] = recipe_ings
    analyzed["main_missing"] = main_missing
    analyzed["optional_missing"] = optional_missing
    analyzed["missing_ingredients"] = main_missing + optional_missing
    analyzed["matched_ingredients"] = matched
    analyzed["match_score"] = score
    analyzed["source"] = "database_verified" if not main_missing else "database_partial"
    return analyzed

def ask_gemini_for_database_assist(recipe: dict, user_ingredients: List[IngredientItem], servings: int) -> dict:
    """Khi đã có món trong database, Gemini chỉ hỗ trợ: thiếu gì, thay bằng gì, chỉnh khẩu phần."""
    user_text = ingredients_to_text(user_ingredients)
    recipe_ings = recipe.get("recipe_ingredients") or get_recipe_ingredients(recipe["id"])
    recipe_text = "\n".join([
        f"- {x['name']} ({x.get('quantity_desc') or 'không rõ lượng'}, {'chính' if x['is_main'] else 'phụ'})"
        for x in recipe_ings
    ])
    missing_text = ", ".join(recipe.get("missing_ingredients") or []) or "Không thiếu nguyên liệu đáng kể"

    prompt = f'''
Bạn là trợ lý nấu ăn AI. Món đã được tìm thấy trong DATABASE, vì vậy KHÔNG được tạo món mới.

Món database: {recipe['name']}
Khẩu phần người dùng muốn: {servings} người

Người dùng đang có:
{user_text}

Công thức database cần:
{recipe_text}

Nguyên liệu người dùng đang thiếu:
{missing_text}

Nhiệm vụ:
1. Giữ nguyên tên món database.
2. Nếu thiếu nguyên liệu phụ như hành lá, gợi ý nguyên liệu thay thế gần gũi ở Việt Nam.
3. Nếu thiếu nguyên liệu chính, nói rõ món vẫn có thể làm phiên bản đơn giản hay nên mua thêm.
4. Điều chỉnh hướng dẫn nấu theo khẩu phần {servings} người và nguyên liệu người dùng có.
5. Trả về JSON hợp lệ, không markdown.

Schema:
{{
  "note": "Nhận xét ngắn về mức độ đủ nguyên liệu và khẩu phần",
  "instructions": "1. ...\\n2. ...",
  "alternatives": ["Thiếu A có thể thay bằng B", "..."],
  "match_score": 95
}}
'''
    response = gemini_client.models.generate_content(model="gemini-2.5-flash", contents=prompt)
    data = clean_gemini_json(response.text)
    if not isinstance(data.get("alternatives", []), list):
        data["alternatives"] = [str(data.get("alternatives"))]
    try:
        data["match_score"] = max(0, min(100, int(data.get("match_score", recipe.get("match_score", 90)))))
    except Exception:
        data["match_score"] = recipe.get("match_score", 90)
    return data

def ask_gemini_for_pro_recipe(user_ingredients: List[IngredientItem], servings: int, db_recipes: Optional[List[dict]] = None) -> dict:
    user_text = ingredients_to_text(user_ingredients)
    recipe_text = ""
    if db_recipes:
        blocks = []
        for r in db_recipes[:5]:
            ing = get_recipe_ingredients(r["id"])
            ing_text = "; ".join([f"{x['name']} ({x.get('quantity_desc') or 'không rõ lượng'}, {'chính' if x['is_main'] else 'phụ'})" for x in ing])
            blocks.append(f"- ID {r['id']} | {r['name']} | Nguyên liệu công thức: {ing_text} | Hướng dẫn: {r['instructions']}")
        recipe_text = "\n".join(blocks)

    prompt = f"""
Bạn là đầu bếp AI cho app AI Kitchen Pro.
Người dùng muốn nấu cho {servings} người.
Người dùng đang có nguyên liệu:
{user_text}

Các món tìm thấy trong database theo tên nguyên liệu:
{recipe_text if recipe_text else 'Không có món phù hợp trong database.'}

Nhiệm vụ:
1. Ưu tiên tạo món từ đúng nguyên liệu người dùng đang có.
2. KHÔNG chọn món database nếu món đó thiếu nguyên liệu chính như thịt/cá/tôm/trứng/đậu phụ/rau chính.
3. Nếu người dùng chỉ có 1-2 nguyên liệu, hãy gợi ý món đơn giản từ chính nguyên liệu đó.
4. Nếu thiếu nguyên liệu phụ như hành, tỏi, tiêu, hãy ghi trong missing_ingredients và gợi ý thay thế trong alternatives.
5. Chấm điểm match_score từ 0-100 dựa trên mức độ đủ nguyên liệu và phù hợp số lượng.
6. Hướng dẫn nấu phải rõ ràng, theo khẩu phần {servings} người.

Chỉ trả về JSON hợp lệ, không markdown:
{{
  "name": "Tên món",
  "instructions": "1. ...\\n2. ...",
  "image_url": "https://via.placeholder.com/600x400?text=AI+Kitchen",
  "note": "Nhận xét ngắn về khẩu phần/số lượng",
  "source": "database_gemini hoặc gemini_ai",
  "match_score": 92,
  "missing_ingredients": ["..."],
  "alternatives": ["..."]
}}
"""
    response = gemini_client.models.generate_content(model="gemini-2.5-flash", contents=prompt)
    data = clean_gemini_json(response.text)
    return normalize_ai_recipe(data, "database_gemini" if db_recipes else "gemini_ai")

# =========================
# API BASIC
# =========================
@app.get("/")
def read_root():
    return {"message": "AI Kitchen Pro API đang hoạt động"}

@app.post("/api/register")
def register(user: UserAuth):
    if not user.username or not user.password:
        raise HTTPException(status_code=400, detail="Vui lòng nhập tài khoản và mật khẩu")
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Không thể kết nối Database")
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT id FROM users WHERE username=%s", (user.username,))
        if cursor.fetchone():
            raise HTTPException(status_code=400, detail="Tên đăng nhập đã tồn tại")
        cursor.execute("INSERT INTO users(username,password,fullname) VALUES(%s,%s,%s)", (user.username, user.password, user.fullname))
        conn.commit()
        return {"message": "Đăng ký thành công"}
    finally:
        cursor.close(); conn.close()

@app.post("/api/login")
def login(user: UserAuth):
    rows = fetch_all("SELECT id, username, fullname FROM users WHERE username=%s AND password=%s", (user.username, user.password))
    if rows:
        return {"user": rows[0]}
    raise HTTPException(status_code=401, detail="Sai tài khoản hoặc mật khẩu")

@app.get("/api/ingredients")
def get_ingredients():
    rows = fetch_all("SELECT name, category FROM ingredients ORDER BY name ASC")
    return {"status": "success", "data": rows}

@app.get("/api/recipes")
def get_all_recipes():
    rows = fetch_all("SELECT * FROM recipes ORDER BY id DESC")
    return {"status": "success", "data": rows}

# =========================
# API SUGGEST PRO
# =========================
@app.post("/api/suggest-recipes")
def suggest_recipes(request: IngredientRequest):
    if not request.ingredients:
        return {"status": "success", "data": []}

    # Chuẩn hóa tên nguyên liệu trước khi tìm database.
    # Ví dụ: Ca_Rot / ca_rot / ca rot đều thành "Cà rốt"; Trung thành "Trứng gà".
    normalized_map = {}
    for item in request.ingredients:
        item.name = canonical_name(item.name)
        if not item.name:
            continue
        key = _key_name(item.name)
        if key not in normalized_map:
            normalized_map[key] = item.name
    ingredient_names = list(normalized_map.values())
    if not ingredient_names:
        return {"status": "success", "data": [], "message": "Chưa có nguyên liệu hợp lệ"}
    format_strings = ','.join(['%s'] * len(ingredient_names))

    # Lấy các món có trùng ít nhất 1 nguyên liệu, sau đó tự chấm điểm.
    # Nếu có món đủ nguyên liệu chính trong database => trả nhiều món database phù hợp.
    # Gemini chỉ hỗ trợ thay thế phần thiếu / chỉnh hướng dẫn, không tạo card trùng.
    query = f"""
        SELECT DISTINCT r.id, r.name, r.instructions, r.image_url
        FROM recipes r
        WHERE EXISTS (
            SELECT 1 FROM recipe_ingredients ri
            JOIN ingredients i ON ri.ingredient_id = i.id
            WHERE ri.recipe_id = r.id AND i.name IN ({format_strings})
        )
        LIMIT 100
    """
    db_recipes = fetch_all(query, tuple(ingredient_names))
    analyzed_recipes = [analyze_database_recipe(r, request.ingredients) for r in db_recipes]

    database_matches = [r for r in analyzed_recipes if len(r.get("main_missing", [])) == 0]
    if database_matches:
        # Có nhiều nguyên liệu thì trả về NHIỀU món đủ nguyên liệu chính, thay vì chỉ 1 món.
        # Sắp xếp ưu tiên:
        # 1) Điểm phù hợp cao
        # 2) Match được nhiều nguyên liệu người dùng có
        # 3) Ít thiếu nguyên liệu phụ hơn
        sorted_matches = sorted(
            database_matches,
            key=lambda x: (
                x.get("match_score", 0),
                len(x.get("matched_ingredients", [])),
                -len(x.get("optional_missing", []))
            ),
            reverse=True
        )

        result_recipes = []
        seen_recipe_ids = set()

        # Giới hạn 8 món để giao diện không bị quá dài và API không quá chậm.
        for recipe in sorted_matches[:8]:
            if recipe.get("id") in seen_recipe_ids:
                continue
            seen_recipe_ids.add(recipe.get("id"))

            # Mặc định đã là món database đủ nguyên liệu chính.
            recipe["source"] = "database_verified"
            recipe["alternatives"] = []
            recipe["note"] = "Món này đủ nguyên liệu chính trong database."

            # Chỉ cần Gemini hỗ trợ khi thiếu nguyên liệu phụ hoặc cần chỉnh khẩu phần.
            # Nếu Gemini lỗi thì vẫn trả món database bình thường.
            try:
                assist = ask_gemini_for_database_assist(recipe, request.ingredients, request.servings)
                recipe["instructions"] = assist.get("instructions") or recipe.get("instructions")
                recipe["alternatives"] = assist.get("alternatives", [])
                recipe["note"] = assist.get("note") or recipe["note"]
                recipe["match_score"] = assist.get("match_score", recipe.get("match_score", 90))
            except Exception as e:
                print(f"Lỗi Gemini hỗ trợ món database {recipe.get('name')}:", e)
                if recipe.get("optional_missing"):
                    recipe["note"] = "Món này đủ nguyên liệu chính. Một vài nguyên liệu phụ có thể thiếu, bạn có thể bỏ qua hoặc thay thế."
                else:
                    recipe["note"] = "Món này khớp với database."

            # Frontend chỉ cần các field gọn; bỏ field nội bộ.
            for k in ["recipe_ingredients", "main_missing", "optional_missing", "matched_ingredients"]:
                recipe.pop(k, None)

            result_recipes.append(recipe)

        return {
            "status": "success",
            "data": result_recipes,
            "source": "database_verified",
            "message": f"Tìm thấy {len(result_recipes)} món đủ nguyên liệu chính."
        }

    # Nếu không có món nào đủ nguyên liệu chính, mới để Gemini sáng tạo / điều chỉnh món.
    try:
        ai_recipe = ask_gemini_for_pro_recipe(request.ingredients, request.servings, analyzed_recipes if analyzed_recipes else None)
        return {"status": "success", "data": [ai_recipe], "source": ai_recipe.get("source")}
    except Exception as e:
        print("Lỗi Gemini:", e)
        # Không fallback về món thiếu nguyên liệu chính nữa, vì sẽ gây hiểu nhầm
        # kiểu chỉ có Su hào nhưng lại hiện "Thịt lợn xào su hào".
        first = request.ingredients[0]
        simple_name = f"{first.name} chế biến đơn giản"
        simple_recipe = {
            "name": simple_name,
            "instructions": f"1. Sơ chế {first.name} sạch sẽ.\n2. Nếu có tỏi/hành thì phi thơm, nếu không có thì luộc hoặc xào đơn giản.\n3. Nêm muối, nước mắm hoặc gia vị vừa ăn.\n4. Dùng nóng.",
            "image_url": f"https://placehold.co/600x400?text={first.name.replace(' ', '+')}",
            "note": "Không có món database nào đủ nguyên liệu chính, nên hệ thống gợi ý món đơn giản từ nguyên liệu bạn đang có.",
            "source": "simple_fallback",
            "match_score": 60,
            "missing_ingredients": [],
            "alternatives": ["Có thể thêm tỏi, hành lá hoặc tiêu nếu có để món thơm hơn"]
        }
        return {"status": "success", "data": [simple_recipe], "source": "simple_fallback"}

@app.post("/api/detect-image")
async def detect_ingredients_from_image(file: UploadFile = File(...)):
    if model is None:
        raise HTTPException(status_code=500, detail="Chưa có hoặc chưa load được file best.pt")
    try:
        image_bytes = await file.read()
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        results = model(image)
        counter = Counter()
        for r in results:
            for box in r.boxes:
                class_id = int(box.cls[0])
                class_name = model.names[class_id]
                vn_name = canonical_name(translate_dict.get(class_name, class_name))
                counter[vn_name] += 1
        items = [{"name": name, "count": count, "unit": unit_dict.get(name, "cái")} for name, count in counter.items()]
        return {"status": "success", "filename": file.filename, "detected_ingredients": items}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Lỗi xử lý ảnh: {str(e)}")

# =========================
# HISTORY / FAVORITE / STATS
# =========================
@app.post("/api/save-history")
def save_history(history: HistoryCreate):
    execute("""
        INSERT INTO user_history(user_id, recipe_name, ingredients_used, source, instructions, image_url, match_score, missing_ingredients, alternatives, note)
        VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """, (history.user_id, history.recipe_name, history.ingredients_used, history.source, history.instructions, history.image_url,
          history.match_score, history.missing_ingredients, history.alternatives, history.note))
    return {"status": "success", "message": "Đã lưu lịch sử"}

@app.get("/api/history/{user_id}")
def get_history(user_id: int):
    rows = fetch_all("""
        SELECT id, recipe_name, ingredients_used, source, instructions, image_url, created_at,
               match_score, missing_ingredients, alternatives, note
        FROM user_history WHERE user_id=%s ORDER BY created_at DESC
    """, (user_id,))
    return {"status": "success", "data": rows}

@app.post("/api/favorites")
def add_favorite(fav: FavoriteCreate):
    execute("""
        INSERT INTO favorite_recipes(user_id, recipe_name, ingredients_used, source, instructions, image_url, match_score, missing_ingredients, alternatives, note)
        VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """, (fav.user_id, fav.recipe_name, fav.ingredients_used, fav.source, fav.instructions, fav.image_url,
          fav.match_score, fav.missing_ingredients, fav.alternatives, fav.note))
    return {"status": "success", "message": "Đã lưu món yêu thích"}

@app.get("/api/favorites/{user_id}")
def get_favorites(user_id: int):
    rows = fetch_all("""
        SELECT id, recipe_name, ingredients_used, source, instructions, image_url, created_at,
               match_score, missing_ingredients, alternatives, note
        FROM favorite_recipes WHERE user_id=%s ORDER BY created_at DESC
    """, (user_id,))
    return {"status": "success", "data": rows}

@app.delete("/api/favorites/{favorite_id}")
def delete_favorite(favorite_id: int):
    execute("DELETE FROM favorite_recipes WHERE id=%s", (favorite_id,))
    return {"status": "success", "message": "Đã xóa yêu thích"}

@app.get("/api/stats/{user_id}")
def get_stats(user_id: int):
    # 1) Tổng số món đã nấu
    total_history = fetch_all(
        "SELECT COUNT(*) AS total FROM user_history WHERE user_id=%s",
        (user_id,)
    )[0]["total"]

    # 2) Món nấu nhiều nhất
    top_rows = fetch_all("""
        SELECT recipe_name, COUNT(*) AS cook_count
        FROM user_history
        WHERE user_id=%s
        GROUP BY recipe_name
        ORDER BY cook_count DESC, MAX(created_at) DESC
        LIMIT 1
    """, (user_id,))
    top_recipe = top_rows[0] if top_rows else {"recipe_name": "Chưa có", "cook_count": 0}

    # 3) Biểu đồ mini 7 ngày gần nhất
    today = date.today()
    start_day = today - timedelta(days=6)
    chart_rows = fetch_all("""
        SELECT DATE(created_at) AS cook_date, COUNT(*) AS total
        FROM user_history
        WHERE user_id=%s AND DATE(created_at) BETWEEN %s AND %s
        GROUP BY DATE(created_at)
        ORDER BY cook_date ASC
    """, (user_id, start_day, today))

    count_by_date = {str(row["cook_date"]): row["total"] for row in chart_rows}
    weekday_vi = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
    mini_chart = []
    for i in range(7):
        d = start_day + timedelta(days=i)
        mini_chart.append({
            "date": d.isoformat(),
            "label": weekday_vi[d.weekday()],
            "total": int(count_by_date.get(d.isoformat(), 0))
        })

    recent = fetch_all("""
        SELECT recipe_name, created_at
        FROM user_history
        WHERE user_id=%s
        ORDER BY created_at DESC
        LIMIT 5
    """, (user_id,))

    return {
        "status": "success",
        "data": {
            "total_history": total_history,
            "top_recipe": top_recipe,
            "mini_chart": mini_chart,
            "recent": recent
        }
    }
