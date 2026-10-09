const express = require("express");
const mongoose = require("mongoose");
const path = require("path");

const app = express();
const PORT = 3000;

// MongoDB connection
mongoose.connect("mongodb://127.0.0.1:27017/amazonDB")
  .then(() => console.log("MongoDB Connected ✅"))
  .catch(err => console.log("MongoDB Error:", err));

// Middleware
app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

// Product Schema
const productSchema = new mongoose.Schema({
  name: String,
  price: Number,
  image: String
});

const Product = mongoose.model("Product", productSchema);

// Add products
app.get("/add-products", async (req, res) => {
  try {
    await Product.deleteMany();

    await Product.insertMany([
      { name: "Laptop", price: 50000, image: "laptop.jpg" },
      { name: "Mobile", price: 20000, image: "mobile.jpg" },
      { name: "Headphones", price: 2000, image: "headphones.jpg" }
    ]);

    res.send("Products added successfully");
  } catch (err) {
    console.log(err);
    res.status(500).send("Error adding products");
  }
});

// Get products
app.get("/products", async (req, res) => {
  try {
    const data = await Product.find();
    res.json(data);
  } catch (err) {
    console.log(err);
    res.status(500).send("Error fetching products");
  }
});

// Start server (ONLY ONCE)
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});