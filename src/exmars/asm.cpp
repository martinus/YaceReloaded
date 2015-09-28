#include <exmars/exhaust.h>
#include <exmars/insn_help.h>
#include <exmars/insn.h>
#include <string>
#include <sstream>

#include <FitnessEvaluator.h>

std::string dis(const std::vector<int>& ins, unsigned coresize) {
    char *op_s, *mo_s, *ma_s, *mb_s;
    int af, bf;

    switch (ins[0]) {
    case EX_DAT: op_s = "dat"; break;
    case EX_SPL: op_s = "spl"; break;
    case EX_MOV: op_s = "mov"; break;
    case EX_JMP: op_s = "jmp"; break;
    case EX_JMZ: op_s = "jmz"; break;
    case EX_JMN: op_s = "jmn"; break;
    case EX_ADD: op_s = "add"; break;
    case EX_SUB: op_s = "sub"; break;
    case EX_SEQ: op_s = "seq"; break;
    case EX_SNE: op_s = "sne"; break;
    case EX_MUL: op_s = "mul"; break;
    case EX_DIV: op_s = "div"; break;
    case EX_DJN: op_s = "djn"; break;
    case EX_SLT: op_s = "slt"; break;
    case EX_MODM: op_s = "mod"; break;
    case EX_NOP: op_s = "nop"; break;
    case EX_LDP: op_s = "ldp"; break;
    case EX_STP: op_s = "stp"; break;
    default:
        op_s = "???";
    }

    switch (ins[1]) {
    case EX_mF:  mo_s = "f "; break;
    case EX_mA:  mo_s = "a "; break;
    case EX_mB:  mo_s = "b "; break;
    case EX_mAB: mo_s = "ab"; break;
    case EX_mBA: mo_s = "ba"; break;
    case EX_mX:  mo_s = "x "; break;
    case EX_mI:  mo_s = "i "; break;
    default:
        mo_s = "?";
    }

    switch (ins[2]) {
    case EX_DIRECT: ma_s = "$"; break;
    case EX_IMMEDIATE: ma_s = "#"; break;
    case EX_AINDIRECT: ma_s = "*"; break;
    case EX_BINDIRECT: ma_s = "@"; break;
    case EX_APREDEC: ma_s = "{"; break;
    case EX_APOSTINC: ma_s = "}"; break;
    case EX_BPREDEC: ma_s = "<"; break;
    case EX_BPOSTINC: ma_s = ">"; break;
    default: ma_s = "?";
    }

    af = ins[3] <= static_cast<int>(coresize) / 2 ? ins[3] : ins[3] - static_cast<int>(coresize);

    switch (ins[4]) {
    case EX_DIRECT:    mb_s = "$"; break;
    case EX_IMMEDIATE: mb_s = "#"; break;
    case EX_AINDIRECT: mb_s = "*"; break;
    case EX_BINDIRECT: mb_s = "@"; break;
    case EX_APREDEC:   mb_s = "{"; break;
    case EX_APOSTINC:  mb_s = "}"; break;
    case EX_BPREDEC:   mb_s = "<"; break;
    case EX_BPOSTINC:  mb_s = ">"; break;
    default: mb_s = "?";
    }

    bf = ins[5] <= static_cast<int>(coresize) / 2 ? ins[5] : ins[5] - static_cast<int>(coresize);

    char line[256];
    sprintf(line, "%s.%s %s%5d , %s%5d", op_s, mo_s, ma_s, af, mb_s, bf);
    return std::string(line);
}

std::string print(const WarriorAry& w, u32_t coresize) {
    std::stringstream ss;
    ss << "       ORG      START" << std::endl;
    for (size_t i = 0; i < w.ins.size(); ++i) {
        if (w.startOffset == i) {
            ss << "START  ";
        } else {
            ss << "       ";
        }
        ss << dis(w.ins[i], coresize) << std::endl;
    }
    ss << std::endl;
    return ss.str();
}