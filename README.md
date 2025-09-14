# 🔧 Galaxy Boot Logo Patcher 
A simple tool written in Shell that can change bootlogo on Samsung devices. Works on any rom

## ⚙️ To run:
- Make sure you are on Termux with root access
- Put your(s) JPEG('s) on internal storage as "1st.jpg" or "2nd.jpg"
- 1st is the first splash screen (Samsung logo)
- 2nd is the second splash screen (Samsung Galaxy Secured By Knox)

### 📥 Download the script:
```bash
pkg install wget
pkg install p7zip
wget https://raw.githubusercontent.com/Filipemendonca1978/Galaxy-Boot-Logo-Patcher/refs/heads/main/bootpatcher.sh -O bootlogo-patcher.sh
chmod +x ./bootlogo-patcher.sh
```
### 📲 Execute it:
#### Usage: patch|backup|restore|clean|rmwarnings
```bash
patch: changes logo(s)
backup: backup logo
restore: restore old logo
clean: clean scripts environment
rmwarnings: remove unlocked bootloader warnings
```
Example:
```
./bootlogo-patcher.sh patch
```
# 🙏 Credits
## [Filipe Daniel](https://github.com/Filipemendonca1978)
## [Josué de Muniz](https://linktr.ee/josuedemuniz)

