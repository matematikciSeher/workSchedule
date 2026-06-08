import 'package:flutter/material.dart';
import '../../core/theme/app_font_families.dart';
import '../../core/theme/app_theme_controller.dart';
import '../../core/theme/theme_models.dart';
import '../../shared/widgets/decorative_background.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppThemeScope.maybeOf(context);
    if (controller == null) {
      return const Scaffold(
        body: Center(
          child: Text('Tema ayarları yüklenemedi.'),
        ),
      );
    }

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tema ve Yazı Tipi'),
            elevation: 0,
            backgroundColor: Colors.transparent,
            toolbarHeight: 48,
          ),
          body: DecorativeBackground(
            style: BackgroundStyle.elegant,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionLabel(title: 'Görünüm'),
                    const SizedBox(height: 6),
                    _SectionBox(
                      child: _ThemeModeSelector(
                        selected: controller.themeMode,
                        onChanged: controller.setThemeMode,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SectionLabel(title: 'Tema Renkleri'),
                    const SizedBox(height: 6),
                    _SectionBox(
                      child: _ThemeColorButtons(
                        selectedTheme: controller.currentTheme,
                        isDark: controller.themeMode == ThemeMode.dark,
                        onSelected: controller.setTheme,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SectionLabel(title: 'Yazı Tipi & Boyut'),
                    const SizedBox(height: 6),
                    Expanded(
                      child: _SectionBox(
                        child: _FontSettingsPanel(
                          selectedFont: controller.fontFamily,
                          textScale: controller.textScaleFactor,
                          onFontSelected: controller.setFontFamily,
                          onScaleChanged: controller.setTextScaleFactor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionBox extends StatelessWidget {
  const _SectionBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: child,
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({
    required this.selected,
    required this.onChanged,
  });

  final ThemeMode selected;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              label: 'Açık',
              icon: Icons.light_mode_rounded,
              isSelected: selected == ThemeMode.light,
              onTap: () => onChanged(ThemeMode.light),
              activeColor: const Color(0xFFFFB300),
              backgroundColor: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ModeButton(
              label: 'Koyu',
              icon: Icons.dark_mode_rounded,
              isSelected: selected == ThemeMode.dark,
              onTap: () => onChanged(ThemeMode.dark),
              activeColor: const Color(0xFF5C6BC0),
              backgroundColor: const Color(0xFF1E1E2E),
              isDarkStyle: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
    required this.backgroundColor,
    this.isDarkStyle = false,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color backgroundColor;
  final bool isDarkStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isDarkStyle ? Colors.white : theme.colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? activeColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? activeColor : textColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeColorButtons extends StatelessWidget {
  const _ThemeColorButtons({
    required this.selectedTheme,
    required this.isDark,
    required this.onSelected,
  });

  final AppThemeModel selectedTheme;
  final bool isDark;
  final ValueChanged<AppThemeModel> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppThemes.allThemes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final themeModel = AppThemes.allThemes[index];
          final isSelected = selectedTheme.id == themeModel.id;
          final scheme = isDark
              ? themeModel.darkColorScheme
              : themeModel.lightColorScheme;

          return _ThemeColorButton(
            name: themeModel.name,
            primary: scheme.primary,
            secondary: scheme.secondary,
            isSelected: isSelected,
            onTap: () => onSelected(themeModel),
          );
        },
      ),
    );
  }
}

class _ThemeColorButton extends StatelessWidget {
  const _ThemeColorButton({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final Color primary;
  final Color secondary;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onButton = _contrastColor(primary);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 68,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary, secondary],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: onButton,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              if (isSelected)
                const Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(
                    Icons.check_circle,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _contrastColor(Color bg) {
    return bg.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }
}

class _FontSettingsPanel extends StatelessWidget {
  const _FontSettingsPanel({
    required this.selectedFont,
    required this.textScale,
    required this.onFontSelected,
    required this.onScaleChanged,
  });

  final AppFontFamily selectedFont;
  final double textScale;
  final ValueChanged<AppFontFamily> onFontSelected;
  final ValueChanged<double> onScaleChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final previewHeight = (constraints.maxHeight - 34 - 10 - 48 - 6)
            .clamp(48.0, 120.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: AppFontFamilies.all.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final font = AppFontFamilies.all[index];
                  final isSelected = font.id == selectedFont.id;

                  return _FontChip(
                    font: font,
                    isSelected: isSelected,
                    onTap: () => onFontSelected(font),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  Text(
                    'A',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 14,
                        ),
                      ),
                      child: Slider(
                        value: textScale,
                        min: 0.8,
                        max: 1.5,
                        divisions: 14,
                        label: '${(textScale * 100).round()}%',
                        onChanged: onScaleChanged,
                      ),
                    ),
                  ),
                  Text(
                    'A',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 36,
                    child: Text(
                      '${(textScale * 100).round()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: previewHeight,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.35,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Örnek metin — Çalışma Takvimi',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: selectedFont.style(
                      TextStyle(
                        fontSize: 16 * textScale,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FontChip extends StatelessWidget {
  const _FontChip({
    required this.font,
    required this.isSelected,
    required this.onTap,
  });

  final AppFontFamily font;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.7)
                : theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.4,
                  ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.dividerColor.withValues(alpha: 0.3),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Text(
            font.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: font.style(
              TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
