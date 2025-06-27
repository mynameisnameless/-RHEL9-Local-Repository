# RHEL 9 Local Repository Setup

สคริปต์นี้ใช้สำหรับการตั้งค่า Local Repository บน Red Hat Enterprise Linux 9 โดยใช้ DVD/ISO ที่ mount ผ่าน CD/DVD drive

## คุณสมบัติ

- Mount DVD/ISO ของ RHEL 9 อัตโนมัติ
- สร้างไฟล์ repository configuration
- ตั้งค่า BaseOS และ AppStream repositories
- ทำความสะอาดและอัพเดต repository cache

## ข้อกำหนดระบบ

- Red Hat Enterprise Linux 9
- สิทธิ์ root หรือ sudo
- RHEL 9 DVD/ISO ที่ใส่ในเครื่อง CD/DVD drive

## การใช้งาน

### 1. เตรียมไฟล์สคริปต์

```bash
# ดาวน์โหลดหรือคัดลอกสคริปต์
chmod +x rhel9_local_repo.sh
```

### 2. รันสคริปต์

```bash
sudo ./rhel9_local_repo.sh
```

หรือ

```bash
su -
./rhel9_local_repo.sh
```

## สิ่งที่สคริปต์จะทำ

1. **ตรวจสอบสิทธิ์**: ตรวจสอบว่ารันด้วย root หรือไม่
2. **ตรวจสอบอุปกรณ์**: ตรวจสอบว่า `/dev/sr0` มีอยู่หรือไม่
3. **Mount DVD/ISO**: Mount ไปยัง `/mnt/disc`
4. **สร้าง Repository Configuration**: สร้างไฟล์ `/etc/yum.repos.d/rhel9.repo`
5. **อัพเดต Cache**: ทำความสะอาดและสร้าง cache ใหม่

## ไฟล์ที่สร้างขึ้น

สคริปต์จะสร้างไฟล์ repository configuration ที่ `/etc/yum.repos.d/rhel9.repo` ประกอบด้วย:

- **BaseOS Repository**: แพ็กเกจพื้นฐานของ RHEL 9
- **AppStream Repository**: แพ็กเกจเพิ่มเติมและ applications

## การตรวจสอบผลลัพธ์

หลังจากรันสคริปต์เสร็จแล้ว สามารถตรวจสอบได้ด้วย:

```bash
# ดู repository ที่ใช้งานได้
yum repolist

# ตรวจสอบว่า mount สำเร็จหรือไม่
df -h | grep /mnt/disc

# ทดสอบการค้นหาแพ็กเกจ
yum search httpd
```

## การแก้ไขปัญหา

### DVD/ISO ไม่อยู่ใน /dev/sr0

ถ้า DVD/ISO อยู่ในตำแหน่งอื่น แก้ไขตัวแปร `DEVICE` ในสคริปต์:

```bash
DEVICE="/dev/sr1"  # หรือตำแหน่งที่ถูกต้อง
```

### ไม่สามารถ Mount ได้

ตรวจสอบว่า:
- DVD/ISO ใส่ในเครื่องแล้ว
- ไม่มีไฟล์อื่นใช้งาน device อยู่
- มีสิทธิ์ในการเข้าถึง device

### Repository ไม่ทำงาน

ตรวจสอบ:
```bash
# ตรวจสอบว่าไฟล์ repo มีอยู่หรือไม่
ls -la /etc/yum.repos.d/rhel9.repo

# ตรวจสอบเนื้อหาไฟล์
cat /etc/yum.repos.d/rhel9.repo
```

## การถอดการติดตั้ง

หากต้องการลบ local repository:

```bash
# ลบไฟล์ repository
sudo rm /etc/yum.repos.d/rhel9.repo

# Unmount DVD
sudo umount /mnt/disc

# ทำความสะอาด cache
sudo yum clean all
```

## ข้อจำกัด

- ต้องใส่ DVD/ISO ในเครื่องตลอดเวลาที่ใช้งาน
- สคริปต์ออกแบบมาสำหรับ RHEL 9 เท่านั้น
- ต้องรันด้วยสิทธิ์ root

## ความปลอดภัย

- สคริปต์จะตรวจสอบ GPG signature ของแพ็กเกจ
- ใช้ GPG key จาก Red Hat official
- Metadata จะไม่หมดอายุ (เหมาะสำหรับ offline environment)

## ผู้พัฒนา

สคริปต์นี้เป็น bash script สำหรับการตั้งค่า RHEL 9 local repository อย่างง่าย

## License

สคริปต์นี้เป็น open source และสามารถใช้งานได้ฟรี
