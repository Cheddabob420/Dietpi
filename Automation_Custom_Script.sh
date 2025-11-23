#!/bin/bash
set -e

WEBROOT="/var/www/food-lister"

echo "[*] Creating food-lister web root at: $WEBROOT"
mkdir -p "$WEBROOT"

#################################
# index.html
#################################
cat > "$WEBROOT/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Food Lister</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="style.css" />
</head>
<body>
  <header class="top-bar">
    <h1>Food Lister</h1>
    <p>Tap dinners to build a shared shopping list.</p>
  </header>

  <main class="layout">
    <section class="recipes-panel">
      <h2>Dinners</h2>
      <div id="recipes" class="recipes-grid"></div>
    </section>

    <section class="list-panel">
      <h2>Shopping List</h2>

      <div class="list-actions">
        <div class="manual-add">
          <input
            id="manualItem"
            type="text"
            placeholder="Add custom item (e.g. Milk)"
          />
          <button id="addManualBtn">Add</button>
        </div>

        <div class="export-buttons">
          <button id="copyListBtn">Copy List</button>
          <button id="downloadListBtn">Download Checklist</button>
          <button id="clearListBtn" class="danger">Clear</button>
        </div>
      </div>

      <ul id="shoppingList" class="shopping-list"></ul>
    </section>
  </main>

  <footer class="footer">
    <small>Saved on this device · Add to Home Screen for quick access</small>
  </footer>

  <script src="app.js"></script>
</body>
</html>
EOF

#################################
# style.css
#################################
cat > "$WEBROOT/style.css" <<'EOF'
:root {
  --bg: #0f172a;
  --bg-alt: #111827;
  --card: #020617;
  --accent: #22c55e;
  --accent-soft: rgba(34, 197, 94, 0.14);
  --text-main: #e5e7eb;
  --text-muted: #9ca3af;
  --danger: #ef4444;
  --border-soft: #1f2937;
  --radius-lg: 16px;
  --radius-sm: 10px;
  --shadow-soft: 0 18px 40px rgba(0, 0, 0, 0.4);
  --font-main: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

*,
*::before,
*::after {
  box-sizing: border-box;
}

html, body {
  margin: 0;
  padding: 0;
  height: 100%;
}

body {
  background: radial-gradient(circle at top, #1f2937 0, #020617 45%, #000000 100%);
  color: var(--text-main);
  font-family: var(--font-main);
  -webkit-font-smoothing: antialiased;
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.top-bar {
  padding: 1rem 1.2rem 0.3rem;
  text-align: center;
}

.top-bar h1 {
  font-size: 1.6rem;
  margin: 0;
}

.top-bar p {
  margin: 0.25rem 0 0.8rem;
  color: var(--text-muted);
  font-size: 0.9rem;
}

.layout {
  flex: 1;
  display: grid;
  gap: 0.75rem;
  padding: 0.8rem;
}

@media (min-width: 800px) {
  .layout {
    grid-template-columns: 1.2fr 1fr;
    max-width: 1200px;
    margin: 0 auto;
  }
}

.recipes-panel,
.list-panel {
  background: linear-gradient(135deg, rgba(15,23,42,0.96), rgba(15,23,42,0.94));
  border-radius: var(--radius-lg);
  padding: 0.9rem;
  border: 1px solid rgba(15, 23, 42, 0.9);
  box-shadow: var(--shadow-soft);
  display: flex;
  flex-direction: column;
}

.recipes-panel h2,
.list-panel h2 {
  font-size: 1.1rem;
  margin: 0 0 0.6rem;
}

.recipes-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
  gap: 0.5rem;
  overflow-y: auto;
  max-height: 60vh;
  padding-right: 0.2rem;
}

.recipe-btn {
  border: 1px solid var(--border-soft);
  border-radius: var(--radius-sm);
  background: radial-gradient(circle at top left, rgba(34,197,94,0.18), rgba(15,23,42,0.96));
  color: var(--text-main);
  padding: 0.55rem 0.6rem;
  text-align: left;
  font-size: 0.8rem;
  cursor: pointer;
  transition: transform 0.08s ease, box-shadow 0.08s ease, border-color 0.08s ease, background 0.08s ease;
}

.recipe-btn .recipe-name {
  font-weight: 600;
  display: block;
  margin-bottom: 0.15rem;
}

.recipe-btn small {
  color: var(--text-muted);
  font-size: 0.7rem;
}

.recipe-btn:active {
  transform: scale(0.96);
  border-color: var(--accent);
  background: radial-gradient(circle at top left, rgba(34,197,94,0.28), rgba(15,23,42,0.96));
}

.list-panel {
  max-height: 80vh;
}

.list-actions {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}

.manual-add {
  display: flex;
  gap: 0.4rem;
}

.manual-add input {
  flex: 1;
  border-radius: 999px;
  border: 1px solid var(--border-soft);
  background: rgba(15,23,42,0.9);
  color: var(--text-main);
  padding: 0.35rem 0.8rem;
  font-size: 0.85rem;
  outline: none;
}

.manual-add input::placeholder {
  color: var(--text-muted);
}

.manual-add button {
  border-radius: 999px;
  border: none;
  background: var(--accent);
  color: #022c22;
  font-weight: 600;
  padding: 0.35rem 0.9rem;
  font-size: 0.8rem;
  cursor: pointer;
}

.export-buttons {
  display: flex;
  gap: 0.4rem;
  flex-wrap: wrap;
}

.export-buttons button {
  flex: 1;
  min-width: 0;
  border-radius: 999px;
  border: 1px solid var(--border-soft);
  background: rgba(15,23,42,0.9);
  color: var(--text-main);
  font-size: 0.75rem;
  padding: 0.3rem 0.4rem;
  cursor: pointer;
}

.export-buttons button.danger {
  border-color: rgba(239,68,68,0.35);
  color: #fecaca;
}

.shopping-list {
  list-style: none;
  margin: 0;
  padding: 0;
  border-radius: 12px;
  background: rgba(15,23,42,0.85);
  border: 1px solid var(--border-soft);
  min-height: 220px;
  max-height: 58vh;
  overflow-y: auto;
}

.shopping-list li {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.4rem;
  padding: 0.35rem 0.6rem;
  border-bottom: 1px solid rgba(15,23,42,0.95);
}

.shopping-list li:last-child {
  border-bottom: none;
}

.shopping-list li span.item-name {
  font-size: 0.85rem;
}

.shopping-list li span.qty {
  font-size: 0.8rem;
  color: var(--accent);
  margin-left: 0.35rem;
}

.qty-controls {
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.qty-btn {
  width: 1.7rem;
  height: 1.7rem;
  border-radius: 999px;
  border: 1px solid var(--border-soft);
  background: rgba(15,23,42,0.9);
  color: var(--text-main);
  font-size: 0.9rem;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.qty-value {
  min-width: 1.3rem;
  text-align: center;
  font-size: 0.8rem;
}

.remove-btn {
  border-radius: 999px;
  border: none;
  background: rgba(15,23,42,0.9);
  color: var(--danger);
  font-size: 0.85rem;
  width: 1.7rem;
  height: 1.7rem;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.footer {
  text-align: center;
  padding: 0.5rem 0.8rem 0.7rem;
  color: var(--text-muted);
  font-size: 0.7rem;
}
EOF

#################################
# app.js
#################################
cat > "$WEBROOT/app.js" <<'EOF'
let shoppingList = [];

// --- Recipes (your list) ---

const recipes = {
  "Spaghetti": [
    "Spaghetti noodles",
    "Tomato sauce",
    "Ground beef"
  ],
  "Tacos": [
    "Tortillas",
    "Ground beef",
    "Taco seasoning",
    "Cheese",
    "Salsa"
  ],
  "Smash Burgers": [
    "Ground beef",
    "Potatoes",
    "Cheese"
  ],
  "Chili": [
    "Ground beef",
    "Chili beans",
    "Tomato sauce",
    "Chili powder"
  ],
  "Chicken Gravy w/ Mashed Potatoes": [
    "Chicken breasts",
    "Gravy mix",
    "Potatoes"
  ],
  "Loaded Chicken Potatoes": [
    "Chicken breasts",
    "Potatoes"
  ],
  "Hamburgers": [
    "Ground beef",
    "Hamburger buns"
  ],
  "Hot Dogs": [
    "Hot dog buns",
    "Hot dogs"
  ],
  "Dirty Rice": [
    "Ground beef",
    "Box of dirty rice mix"
  ],
  "Jambalaya": [
    "Long sausage",
    "Box of jambalaya mix"
  ],
  "Salmon": [
    "Salmon fillets",
    "Lemon",
    "Ritz crackers"
  ],
  "Salmon Patties": [
    "Canned salmon",
    "Breadcrumbs",
    "Eggs"
  ],
  "Meatloaf": [
    "Ground beef",
    "Breadcrumbs",
    "Eggs",
    "Ketchup"
  ],
  "Chicken Cacciatore": [
    "Chicken breasts",
    "Ragu sauce"
  ],
  "Quesadillas": [
    "Tortillas",
    "Queso cheese",
    "Steak"
  ],
  "Chicken Dumplings": [
    "Chicken breasts",
    "Biscuits",
    "Chicken broth"
  ],
  "Pork Loins": [
    "Pork loins",
    "Potatoes"
  ],
  "Broccoli Stuffed Chicken": [
    "Chicken packets",
    "Sides"
  ],
  "Birria Tacos": [
    "Tortillas",
    "Birria meat",
    "Queso cheese"
  ],
  "Pork Chops": [
    "Pork chops",
    "Sides"
  ],
  "Steak Dinner": [
    "Steak",
    "Sides"
  ],
  "Mississippi Pot Roast": [
    "Chuck roast",
    "Beef stew seasoning",
    "Brown gravy mix",
    "Pepperoncini peppers"
  ],
  "BBQ Baskets": [
    "Chicken breasts",
    "BBQ sauce",
    "Biscuits"
  ],
  "Burrito Casserole": [
    "Frozen burritos",
    "Salsa"
  ]
};

// --- Local Storage helpers ---

function loadList() {
  try {
    const raw = localStorage.getItem("shoppingList_v2");
    shoppingList = raw ? JSON.parse(raw) : [];
  } catch (e) {
    console.error("Could not load list:", e);
    shoppingList = [];
  }
}

function saveList() {
  localStorage.setItem("shoppingList_v2", JSON.stringify(shoppingList));
}

// --- Renderers ---

function renderRecipes() {
  const container = document.getElementById("recipes");
  container.innerHTML = "";

  Object.entries(recipes).forEach(([name, items]) => {
    const btn = document.createElement("button");
    btn.className = "recipe-btn";
    btn.innerHTML = `
      <span class="recipe-name">${name}</span>
      <br>
      <small>${items.join(", ")}</small>
    `;
    btn.addEventListener("click", () => addRecipeToList(name));
    container.appendChild(btn);
  });
}

function renderShoppingList() {
  const ul = document.getElementById("shoppingList");
  ul.innerHTML = "";

  if (!shoppingList.length) {
    const li = document.createElement("li");
    li.textContent = "No items yet. Tap a dinner or add items manually.";
    li.style.opacity = "0.7";
    ul.appendChild(li);
    return;
  }

  shoppingList.forEach((entry, index) => {
    const li = document.createElement("li");

    const leftSpan = document.createElement("span");
    leftSpan.className = "item-name";
    leftSpan.textContent = entry.name;

    const qtySpan = document.createElement("span");
    qtySpan.className = "qty";
    qtySpan.textContent = entry.quantity > 1 ? `(x${entry.quantity})` : "";

    const leftWrap = document.createElement("span");
    leftWrap.appendChild(leftSpan);
    leftWrap.appendChild(qtySpan);

    li.appendChild(leftWrap);

    const controls = document.createElement("div");
    controls.className = "qty-controls";

    const minusBtn = document.createElement("button");
    minusBtn.className = "qty-btn";
    minusBtn.textContent = "−";
    minusBtn.addEventListener("click", () => {
      if (entry.quantity > 1) {
        entry.quantity -= 1;
      } else {
        shoppingList.splice(index, 1);
      }
      saveList();
      renderShoppingList();
    });

    const qtyValue = document.createElement("span");
    qtyValue.className = "qty-value";
    qtyValue.textContent = entry.quantity;

    const plusBtn = document.createElement("button");
    plusBtn.className = "qty-btn";
    plusBtn.textContent = "+";
    plusBtn.addEventListener("click", () => {
      entry.quantity += 1;
      saveList();
      renderShoppingList();
    });

    const removeBtn = document.createElement("button");
    removeBtn.className = "remove-btn";
    removeBtn.textContent = "✕";
    removeBtn.title = "Remove item";
    removeBtn.addEventListener("click", () => {
      shoppingList.splice(index, 1);
      saveList();
      renderShoppingList();
    });

    controls.appendChild(minusBtn);
    controls.appendChild(qtyValue);
    controls.appendChild(plusBtn);
    controls.appendChild(removeBtn);

    li.appendChild(controls);
    ul.appendChild(li);
  });
}

// --- Logic ---

function addItemToList(name) {
  if (!name) return;

  const trimmed = name.trim();
  if (!trimmed) return;

  const existing = shoppingList.find(e => e.name.toLowerCase() === trimmed.toLowerCase());
  if (existing) {
    existing.quantity += 1;
  } else {
    shoppingList.push({ name: trimmed, quantity: 1 });
  }
  saveList();
  renderShoppingList();
}

function addRecipeToList(recipeName) {
  const ingredients = recipes[recipeName] || [];
  ingredients.forEach(addItemToList);
}

// --- Export helpers ---

function buildPlainTextList() {
  if (!shoppingList.length) return "Shopping List is empty.";

  return shoppingList
    .map(entry => `${entry.name} x${entry.quantity}`)
    .join("\n");
}

function buildChecklistHTML() {
  const itemsHTML = shoppingList
    .map(entry => {
      const label = `${entry.name}${entry.quantity > 1 ? " x" + entry.quantity : ""}`;
      return `
        <label style="display:flex;align-items:center;gap:0.4rem;margin-bottom:0.4rem;">
          <input type="checkbox" style="width:18px;height:18px;">
          <span>${label}</span>
        </label>
      `;
    })
    .join("");

  return `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Shopping Checklist</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
</head>
<body style="font-family: system-ui, -apple-system, sans-serif; padding: 1rem; max-width: 600px; margin: 0 auto;">
  <h1>Shopping Checklist</h1>
  <p>Tap items as you grab them.</p>
  <hr>
  <div>
    ${itemsHTML || "<p>No items.</p>"}
  </div>
</body>
</html>
`;
}

// --- Events ---

function setupEvents() {
  const manualInput = document.getElementById("manualItem");
  const manualBtn = document.getElementById("addManualBtn");
  const clearBtn = document.getElementById("clearListBtn");
  const copyBtn = document.getElementById("copyListBtn");
  const downloadBtn = document.getElementById("downloadListBtn");

  manualBtn.addEventListener("click", () => {
    const value = manualInput.value.trim();
    if (value) {
      addItemToList(value);
      manualInput.value = "";
      manualInput.focus();
    }
  });

  manualInput.addEventListener("keydown", e => {
    if (e.key === "Enter") {
      manualBtn.click();
    }
  });

  clearBtn.addEventListener("click", () => {
    if (confirm("Clear the entire shopping list?")) {
      shoppingList = [];
      saveList();
      renderShoppingList();
    }
  });

  copyBtn.addEventListener("click", async () => {
    const txt = buildPlainTextList();
    try {
      await navigator.clipboard.writeText(txt);
      alert("Copied to clipboard!");
    } catch (e) {
      alert("Could not copy. You can select and copy manually:\n\n" + txt);
    }
  });

  downloadBtn.addEventListener("click", () => {
    const html = buildChecklistHTML();
    const blob = new Blob([html], { type: "text/html" });
    const url = URL.createObjectURL(blob);

    const a = document.createElement("a");
    a.href = url;
    a.download = "shopping-list.html";
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  });
}

// --- Init ---

document.addEventListener("DOMContentLoaded", () => {
  loadList();
  renderRecipes();
  renderShoppingList();
  setupEvents();
});
EOF

#################################
# Permissions + Lighttpd config
#################################

chown -R www-data:www-data "$WEBROOT"

# Point Lighttpd document root to our app
if [ -f /etc/lighttpd/lighttpd.conf ]; then
  if grep -q 'server.document-root' /etc/lighttpd/lighttpd.conf; then
    sed -i 's|server.document-root *=.*|server.document-root = "/var/www/food-lister"|' /etc/lighttpd/lighttpd.conf
  else
    echo 'server.document-root = "/var/www/food-lister"' >> /etc/lighttpd/lighttpd.conf
  fi
fi

# Restart webserver
if command -v service >/dev/null 2>&1; then
  service lighttpd restart || true
else
  systemctl restart lighttpd || true
fi

echo "[*] Food Lister dashboard deployed to $WEBROOT and Lighttpd restarted."
exit 0
