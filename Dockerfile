# --- DOCKERFILE HARDENING (ALPINE VERSION) ---

# 1. Gunakan Base Image Alpine (Ukuran kecil & Minim celah keamanan)
FROM node:18-alpine

# 2. Tentukan Direktori Kerja
WORKDIR /juice-shop

# 3. Copy file dependensi
COPY package.json package-lock.json ./

# 4. Install dependensi (Hanya untuk production agar lebih aman dan ringan)
RUN npm ci --only=production

# 5. Copy seluruh kode aplikasi
COPY . .

# --- HARDENING: NON-ROOT USER ---
# 6. Buat user biasa 'appuser' agar aplikasi tidak berjalan sebagai Root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# 7. Berikan izin akses folder kerja kepada user tersebut
RUN chown -R appuser:appgroup /juice-shop

# 8. Ganti user aktif menjadi 'appuser'
USER appuser
# -------------------------------

# 9. Ekspos Port aplikasi
EXPOSE 3000

# 10. Jalankan aplikasi
CMD ["npm", "start"]
