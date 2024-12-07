#ifndef DATETIMEVALIDATOR_H
#define DATETIMEVALIDATOR_H

#include <QDateTime>
#include <QValidator>

class DateTimeValidator : public QValidator
{
public:
    DateTimeValidator();

    State validate(QString& input, int& pos) const;
};

#endif /* DATETIMEVALIDATOR_H */
