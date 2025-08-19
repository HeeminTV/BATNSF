#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>
#include <filesystem>
#include <iomanip>

int main(int argc, char* argv[]) {
    if (argc < 4) {
        std::cerr << "Usage:\n"
                  << argv[0] << " <FILEPATH> READ <index> <byte amount>\n"
                  << argv[0] << " <FILEPATH> WRITE <DEC/HEX> <values...>\n";
        return 1;
    }

    std::string filepath = argv[1];
    std::string mode = argv[2];

    if (mode == "READ") {
        size_t index = std::stoul(argv[3]);
        size_t amount = std::stoul(argv[4]);

        std::ifstream in(filepath, std::ios::binary);
        if (!in) {
            std::cerr << "Error: Could not open file for reading.\n";
            return 2; // 파일 없음
        }

        in.seekg(0, std::ios::end);
        size_t filesize = in.tellg();
        if (index + amount - 1 >= filesize) {
            std::cerr << "Error: Index out of range.\n";
            return 3;
        } // fuck i don't care about the range

        in.seekg(index, std::ios::beg);
        for (size_t i = 0; i < amount && in.good(); i++) {
            unsigned char byte;
            in.read(reinterpret_cast<char*>(&byte), 1);
            if (in.gcount() == 0) break;
            std::cout << static_cast<int>(byte);
            if (i != amount - 1) std::cout << " ";
        }
        std::cout << "\n";
    }
    else if (mode == "WRITE") {
        if (argc < 4) {
            std::cerr << "Error: Not enough arguments for WRITE.\n";
            return 1;
        }

        std::string fmt = argv[3];
        std::vector<unsigned char> bytes;

        for (int i = 4; i < argc; i++) {
            if (fmt == "DEC") {
                int val = std::stoi(argv[i]);
                if (val < 0 || val > 255) {
                    std::cerr << "Error: Value out of range (0-255).\n";
                    return 4;
                }
                bytes.push_back(static_cast<unsigned char>(val));
            } else if (fmt == "HEX") {
                unsigned int val;
                std::stringstream ss;
                ss << std::hex << argv[i];
                ss >> val;
                if (val > 255) {
                    std::cerr << "Error: Hex value out of range (00-FF).\n";
                    return 5;
                }
                bytes.push_back(static_cast<unsigned char>(val));
            } else {
                std::cerr << "Error: Invalid format (use DEC or HEX).\n";
                return 6;
            }
        }

        std::filesystem::path p(filepath);
        if (p.has_parent_path()) {
            std::filesystem::create_directories(p.parent_path());
        }

        std::ofstream out(filepath, std::ios::binary | std::ios::app);
        if (!out) {
            std::cerr << "Error: Could not open file for writing.\n";
            return 7;
        }

        out.write(reinterpret_cast<const char*>(bytes.data()), bytes.size());
    }
    else {
        std::cerr << "Error: Invalid mode (use READ or WRITE).\n";
        return 8;
    }

    return 0;
}
