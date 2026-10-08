# Repo fixture audit keamanan CLI (MANUAL QA, bukan unit test)

Unit test (`pnpm --filter scaffdev test:audit`) memakai tarball sintetis.
Folder di sini untuk QA manual end-to-end melawan repo GitHub asli.

## Cara publish (oleh pemilik org)

Per folder di bawah: `git init` + buat repo `scaffdev/<nama-folder>` di GitHub
(public) + push isi folder ke branch default. JANGAN ubah isi file (ekspektasi
di bawah mengacu ke isi ini persis). Semua URL jebakan memakai `example.com`.

## Matriks ekspektasi (`npx scaffdev validate-module https://github.com/scaffdev/<repo>`)

| Repo fixture | Ekspektasi audit |
|---|---|
| `scaff-audit-fixture-clean` | Manifest valid, NOL temuan |
| `scaff-audit-fixture-postinstall` | 1 MEDIUM (`postinstall`) |
| `scaff-audit-fixture-curl-bash` | 1 CRITICAL (`curl … \| bash`) |
| `scaff-audit-fixture-powershell-encoded` | 1 CRITICAL (encoded) |
| `scaff-audit-fixture-base64-eval` | 1 HIGH (base64 + eval) |
| `scaff-audit-fixture-composer` | 1 MEDIUM (`post-install-cmd`) |
| `scaff-audit-fixture-workflow` | `ci.yml` INFO saja; `deploy.yml` CRITICAL |
| `scaff-audit-fixture-vscode` | 1 LOW (task tidak auto-run) |
| `scaff-audit-fixture-docker` | 1 LOW (download saat build) |
| `scaff-audit-fixture-docs-false-positive` | NOL temuan (`.md` tidak dipindai) |
| `scaff-audit-fixture-dep-url` | 1 LOW (dep di luar registry) |
| `scaff-audit-fixture-git-local` | Khusus post-clone (lihat bawah) |

## QA post-clone manual (`scaff-audit-fixture-git-local`)

`.git` tidak bisa di-push, jadi simulasikan lokal:

```bash
git clone <repo-template-apa-saja> coba-audit
cp scaff-audit-fixture-git-local/local-git/config coba-audit/.git/config
mkdir -p coba-audit/.git/hooks
cp scaff-audit-fixture-git-local/local-git/hooks/pre-commit coba-audit/.git/hooks/
# lalu generate via CLI dan pilih audit: ekspektasi = temuan hooksPath +
# hook aktif, instalasi di-pause. JANGAN jalankan hook-nya.
```

## QA alur generate

1. `npx scaffdev --template=<slug> --with=<kode>` → pilih Yes: audit jalan
   SEBELUM clone; temuan HIGH/CRITICAL → default N.
2. Ulangi → pilih No: warning + konfirmasi N; pilih Yes di konfirmasi kedua.
3. Mode interaktif Builder: pilih base + modul fixture (daftarkan dulu bila perlu).
