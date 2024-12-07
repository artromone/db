#include "DateTimeValidator.h"

DateTimeValidator::DateTimeValidator() : QValidator()
{
}

QValidator::State DateTimeValidator::validate(QString& input, int& pos) const
{
    QDateTime dt = QDateTime::fromString(input, "dd.mm.yyyy HH:mm:ss");
    if (dt.isNull())
    {
        return QValidator::Invalid;
    }
    return QValidator::Acceptable;
}
