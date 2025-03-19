import qrcode

# Define the data you want to encode in the QR code
data = "open_popup"

# Create a QR code instance
qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_L,
    box_size=10,
    border=4,
)

# Add data to the QR code
qr.add_data(data)
qr.make(fit=True)

# Create an image from the QR code instance with custom colors
img = qr.make_image(fill_color="#264E36", back_color="white")

# Save the image
img.save("qr_code.png")