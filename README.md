
# Nghiên cứu ứng dụng kỹ thuật Fine-tuning và RAG trên LLM để tự động sinh Promela

[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Hugging Face](https://img.shields.io/badge/%F0%9F%A4%97%20Hugging%20Face-Transformers-yellow?style=for-the-badge)](https://huggingface.co/)
[![LangChain](https://img.shields.io/badge/🦜🔗%20LangChain-RAG-green?style=for-the-badge)](https://python.langchain.com/)
[![SPIN Verifier](https://img.shields.io/badge/Tool-SPIN_Verifier-red?style=for-the-badge)](https://spinroot.com/)

>
> **Đề tài:** Tự động hóa quy trình sinh mã kiểm chứng **Promela** (Process Meta Language) từ mô tả ngôn ngữ tự nhiên. Dự án kết hợp kỹ thuật **Fine-tuning** (QLoRA) trên mô hình ngôn ngữ lớn và **RAG** (Retrieval-Augmented Generation) để cung cấp ngữ cảnh cú pháp chính xác, đồng thời tích hợp cơ chế **Self-Correction** (tự sửa lỗi) dựa trên phản hồi của trình biên dịch SPIN.

---

## 👥 Nhóm tác giả (Authors)

| STT | Thành viên | Mã học viên | Vai trò & Đóng góp chính |
|:---:|------------|:-----------:|--------------------------|
| 1 | **Nguyễn Đức Minh** | 20252092M | Thiết kế kiến trúc hệ thống, Tiền xử lý dữ liệu, Training Model, Tích hợp RAG & SPIN Verifier |
| 2 | **Phạm Văn Quang** | 20251045M | Lựa chọn Model nền, Training Model, Xây dựng và tối ưu RAG Pipeline |
| 3 | **Trần Đức Duy** | 20251049M | Training Model, Nghiên cứu Dataset BEEM, Phát triển cơ chế sửa lỗi (Self-Correction Loop) |

**Giảng viên hướng dẫn:** TS. Trần Nhật Hóa

---

## 📂 Cấu trúc Repository (Project Structure)

Để dự án hoạt động ổn định, mã nguồn được tổ chức thành các thư mục chức năng như sau:

```text
promela-llm-generation/
│
├── data/                       # Quản lý dữ liệu
│   ├── beem_models_data/       # (Input) Thư mục chứa dữ liệu gốc BEEM (XML/PML)
│   └── promela_finetune.jsonl  # (Output) Dữ liệu đã làm sạch để Fine-tune
│
├── notebooks/                  # Mã nguồn (Jupyter Notebooks)
│   ├── 01_Data_Prep/
│   │   ├── BEEM_DataSet.ipynb  # Trích xuất dữ liệu, convert XML -> JSONL
│   │   ├──  Promela_Code.ipynb  # Sinh mô tả cho đoạn mã Promela với các code dữ liệu Stack V2
│   │   └── CheckFileData.ipynb # Kiểm tra thống kê token và định dạng file
│   │
│   ├── 02_Training/
│   │   └── FineTunning_LLM.ipynb # Huấn luyện LLM với QLoRA/PEFT (GPT-OSS:20b)
│   │
│   ├── 03_RAG_Core/
│   │   └── RAG_LangChain.ipynb   # Xây dựng Vector DB và RAG Pipeline
│   │
│   └── 04_Inference_Verify/
│       └── Inference.ipynb       # Chạy sinh mã thử nghiệm (Demo)
│                                 # Pipeline chính: Sinh mã -> Chạy SPIN -> Sửa lỗi
├── requirements.txt            # Danh sách thư viện Python cần thiết
└── README.md                   # Tài liệu hướng dẫn này
```
---

## 🛠️ Yêu cầu hệ thống & Cài đặt (Installation)



**1. Yêu cầu phần cứng & Công cụ**
- Python: Phiên bản 3.10 trở lên.

- GPU: Khuyến nghị NVIDIA GPU (VRAM >= 16GB) để chạy Fine-tuning và Load Model 4-bit.

- SPIN Model Checker: Bắt buộc cài đặt để chạy module kiểm lỗi.

- Linux (Debian/Ubuntu): sudo apt-get install spin

- MacOS/Windows: Tải và biên dịch từ SpinRoot.

- Ollama: Cần thiết nếu chạy Inference Local trong Promela_Code.ipynb. Tải tại ollama.com.

**2. Cài đặt thư viện Python**
Chạy lệnh sau để cài đặt các gói phụ thuộc:

```Bash

pip install -r requirements.txt
```
(Nội dung file requirements.txt được cung cấp trong repo này)

## 🚀 Hướng dẫn sử dụng (Usage Workflow)

<img width="1381" height="769" alt="Tiểu luận Promela drawio" src="https://github.com/user-attachments/assets/76cae5af-c8db-4549-87d7-0a11ea373818" />

**Bước 1: Chuẩn bị dữ liệu**
- Chạy notebook notebooks/01_Data_Prep/BEEM_DataSet.ipynb.

+ Input: Dữ liệu thô từ thư mục data/beem_models_data/.

+ Process: Script sẽ trích xuất cặp <Instruction, Promela Code> từ file XML.

+ Output: File data/promela_finetune.jsonl.

**Bước 2: Huấn luyện mô hình (Fine-tuning)**
- Chạy notebook notebooks/02_Training/FineTunning_LLM.ipynb.

- Load model nền (DeepSeek-Coder hoặc CodeLlama).

- Thực hiện Fine-tuning với cấu hình QLoRA (Quantized Low-Rank Adaptation).

- Lưu Adapter Weights vào thư mục output.

**Bước 3: Khởi tạo RAG (Retrieval)**
- Sử dụng notebooks/03_RAG_Core/RAG_LangChain.ipynb.

- Hệ thống sẽ đọc tài liệu hướng dẫn Promela chuẩn.

- Tạo Vector Database (sử dụng ChromaDB) để lưu trữ kiến thức cú pháp.

**Bước 4: Chạy sinh mã & Tự sửa lỗi (Inference Loop)**

- Chạy notebook notebooks/04_Inference_Verify/Promela_Code.ipynb.

- Đây là quy trình khép kín quan trọng nhất của dự án:

+ User Input: Nhập mô tả hệ thống cần kiểm chứng.

+ Generation: LLM sinh mã ban đầu.
  
+ Verification: Gọi lệnh hệ thống spin -a output.pml.
  
+ RAG: Tìm kiếm cú pháp Promela liên quan.

+ Correction: Nếu SPIN báo lỗi (Syntax/Compile error), lỗi sẽ được gửi lại vào LLM để sinh lại mã mới tối ưu hơn.

## 📊 Phương pháp & Kết quả (Methodology)
- Dự án giải quyết vấn đề khan hiếm dữ liệu Promela và độ phức tạp của cú pháp bằng kiến trúc:

+ Fine-tuning: Giúp Model học được cấu trúc đặc thù của ngôn ngữ Promela (channels, process types, atomic sequences).

+ RAG: Giảm thiểu "ảo giác" (hallucination) bằng cách cung cấp tra cứu thời gian thực vào tài liệu chuẩn.

+ Self-Correction: Tự động sửa các lỗi biên dịch cơ bản mà không cần con người can thiệp.

=> Kết quả: Hệ thống giảm đáng kể tỷ lệ lỗi cú pháp so với Zero-shot prompting và có khả năng sinh được các đoạn mã phức tạp như giao thức mạng, hệ thống phân tán.
