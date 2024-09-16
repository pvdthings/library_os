export type BadgeType =
  'neutral'
  | 'primary'
  | 'warning'
  | 'success'
  | 'error';

export function style(type: BadgeType) {
  switch (type) {
    case 'neutral':
      return 'badge-neutral';
    case 'primary':
      return 'badge-primary';
    case 'warning':
      return 'badge-warning';
    case 'success':
      return 'badge-success'
    case 'error':
      return 'badge-error';
  }
}