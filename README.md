
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
│   │   └── CheckFileData.ipynb # Kiểm tra thống kê token và định dạng file
│   │
│   ├── 02_Training/
│   │   └── FineTunning_LLM.ipynb # Huấn luyện LLM với QLoRA/PEFT
│   │
│   ├── 03_RAG_Core/
│   │   └── RAG_LangChain.ipynb   # Xây dựng Vector DB và RAG Pipeline
│   │
│   └── 04_Inference_Verify/
│       ├── Inference.ipynb       # Chạy sinh mã thử nghiệm (Demo)
│       └── Promela_Code.ipynb    # Pipeline chính: Sinh mã -> Chạy SPIN -> Sửa lỗi
│
├── requirements.txt            # Danh sách thư viện Python cần thiết
└── README.md                   # Tài liệu hướng dẫn này
