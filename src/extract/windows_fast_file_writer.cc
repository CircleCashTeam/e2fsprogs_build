#include "windows_fast_file_writer.h"

bool WindowsFastFileWriter::open(const std::string &filename)
{
    hFile = CreateFileA(
        filename.c_str(),
        GENERIC_WRITE,
        0,
        NULL,
        CREATE_ALWAYS,
        FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,
        NULL);
    return hFile != INVALID_HANDLE_VALUE;
}

bool WindowsFastFileWriter::write(const char *data, size_t size)
{
    if (hFile == INVALID_HANDLE_VALUE)
        return false;

    const char *src = data;
    size_t remaining = size;

    while (remaining > 0)
    {
        size_t copySize = std::min(remaining, bufferSize - bufferPos);
        memcpy(writeBuffer + bufferPos, src, copySize);
        bufferPos += copySize;
        src += copySize;
        remaining -= copySize;

        if (bufferPos == bufferSize)
        {
            if (!flush())
                return false;
        }
    }
    return true;
}

bool WindowsFastFileWriter::flush()
{
    if (hFile == INVALID_HANDLE_VALUE)
        return false;
    if (bufferPos == 0)
        return true;

    DWORD bytesWritten;
    BOOL result = WriteFile(hFile, writeBuffer, bufferPos, &bytesWritten, NULL);

    bufferPos = 0;
    return result && (bytesWritten == bufferPos);
}

bool WindowsFastFileWriter::close()
{
    if (hFile == INVALID_HANDLE_VALUE)
        return true;

    flush(); // ensure data stream flush

    BOOL result = CloseHandle(hFile);
    hFile = INVALID_HANDLE_VALUE;
    return result != FALSE;
}

bool WindowsFastFileWriter::is_open() const
{
    return hFile != INVALID_HANDLE_VALUE;
}