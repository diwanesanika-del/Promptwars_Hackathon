let allProducts = [];
let cart = [];

// Fetch products from backend
fetch("/products")
  .then(res => res.json())
  .then(data => {
    allProducts = data;
    displayProducts(data);
  });

// Display products
function displayProducts(products) {
  const container = document.getElementById("products");
  container.innerHTML = "";

  products.forEach(p => {
    container.innerHTML += `
      <div>
        <h3>${p.name}</h3>
        <img src="${p.image}" width="150">
        <p>₹${p.price}</p>
        <button onclick="addToCart('${p._id}')">Add to Cart</button>
      </div>
    `;
  });
}

// Add to cart
function addToCart(id) {
  const item = allProducts.find(p => p._id === id);
  cart.push(item);
  alert(item.name + " added");
}

// Search
function searchProducts() {
  const value = document.querySelector(".search-input").value.toLowerCase();

  const filtered = allProducts.filter(p =>
    p.name.toLowerCase().includes(value)
  );

  displayProducts(filtered);
}

// Navigation
function goToLogin() {
  window.location.href = "login.html";
}

function goToCart() {
  localStorage.setItem("cart", JSON.stringify(cart));
  window.location.href = "cart.html";
}

function goToOrders() {
  window.location.href = "orders.html";
}
const products = [
  { name: "Bag", price: 500 },
  { name: "Book", price: 200 },
  { name: "Laptop", price: 50000 },
  { name: "Toy", price: 300 }
];

const productContainer = document.getElementById("products");
const searchInput = document.querySelector(".search-input");

// Show products
function displayProducts(items) {
  productContainer.innerHTML = "";

  items.forEach(item => {
    const div = document.createElement("div");
    div.innerHTML = `
      <h3>${item.name}</h3>
      <p>₹${item.price}</p>
      <button>Add to Cart</button>
    `;
    productContainer.appendChild(div);
  });
}

// Initial display
displayProducts(products);

// Search functionality
searchInput.addEventListener("keyup", () => {
  const value = searchInput.value.toLowerCase();

  const filtered = products.filter(p =>
    p.name.toLowerCase().includes(value)
  );

  displayProducts(filtered);
});
function searchProducts() {
  const value = searchInput.value.toLowerCase();

  const filtered = products.filter(p =>
    p.name.toLowerCase().includes(value)
  );

  displayProducts(filtered);
}
const searchInput = document.querySelector(".search-input");
const productContainer = document.getElementById("products");

// Fetch and display products
async function loadProducts() {
  const res = await fetch("/products");
  const data = await res.json();
  displayProducts(data);
}

// Display function
function displayProducts(products) {
  productContainer.innerHTML = "";

  products.forEach(p => {
    const div = document.createElement("div");
    div.innerHTML = `
      <h3>${p.name}</h3>
      <p>₹${p.price}</p>
    `;
    productContainer.appendChild(div);
  });
}

// Search functionality
searchInput.addEventListener("keyup", async () => {
  const value = searchInput.value.toLowerCase();

  const res = await fetch("/products");
  const data = await res.json();

  const filtered = data.filter(p =>
    p.name.toLowerCase().includes(value)
  );

  displayProducts(filtered);
});

// Load products on page start
loadProducts();