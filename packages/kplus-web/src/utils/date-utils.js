//给日期添加或减去固定天数，days可给负数
export function addDays(date, days, isNewInstall = false) {
  if (isNewInstall) {
    date = new Date(date.getTime())
  }
  date.setDate(date.getDate() + days)
  return date
}

export function dateZero(date, isNewInstall = false) {
  if (isNewInstall) {
    date = new Date(date.getTime())
  }
  date.setHours(0)
  date.setMinutes(0)
  date.setSeconds(0)
  date.setMilliseconds(0)
  return date
}

export function todayZero() {
  return dateZero(new Date())
}

export function tomorrowZero() {
  let date = new Date()
  date.setDate(date.getDate() + 1)
  return dateZero(date)
}
