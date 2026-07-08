// pretend-to-do-something.cpp — 占位
// 原始版本在 wr-script/c++-interesting-program/
// 可以在此添加自定义的"假装在做事"终端动画

#include <iostream>
int main(int argc, char* argv[]) {
    std::cout << "Pretending to do something..." << std::endl;
    for (int i = 0; i < 30; i++) {
        std::cout << "\rWorking: " << (i * 100 / 30) << "%" << std::flush;
    }
    std::cout << "\nDone! Good job!" << std::endl;
    return 0;
}
