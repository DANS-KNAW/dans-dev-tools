#!/usr/bin/env python3

import argparse
import os
import random
import shutil


def create_random_file(filepath, minbytes, maxbytes):
    with open(filepath, 'wb') as stream:
        size = random.randint(minbytes, maxbytes)
        stream.write(os.urandom(size))


def create_random_name(minlen, maxlen, name_chars):
    namelen = random.randint(minlen, maxlen)
    random_name = ''
    for _ in range(namelen):
        random_index = random.randint(0, len(name_chars) - 1)
        random_name += chr(name_chars[random_index])
    return random_name


def random_name_creator(name_chars, minlen, maxlen):
    return lambda: create_random_name(minlen, maxlen, name_chars)


def create_random_subdirs(dir, num, name_creator, levels):
    if levels > 0:
        for i in range(num):
            random_dir = '{}/{}'.format(dir, name_creator())
            os.mkdir(random_dir)
            create_random_subdirs(random_dir, num, name_creator, levels - 1)


def create_random_files(dir, num, name_creator, minbytes, maxbytes, level):
    if level == 0:
        for i in range(num):
            random_file = '{}/{}.bin'.format(dir, name_creator())
            create_random_file(random_file, minbytes, maxbytes)
    else:
        for f in os.listdir(dir):
            create_random_files('{}/{}'.format(dir, f), num, name_creator, minbytes, maxbytes, level - 1)


def main():
    parser = argparse.ArgumentParser(add_help=True, allow_abbrev=False)
    parser.add_argument('-o', '--outdir',
                        dest='outdir',
                        help='the directory in which to create random files')
    parser.add_argument('--num-files-per-dir',
                        dest='files_per_dir',
                        type=int,
                        default=10,
                        help='number of random files to create in each directory')
    parser.add_argument('--min-bytes-per-file',
                        dest='min_bytes_per_file',
                        type=int,
                        default=1,
                        help='minimum bytes per file')
    parser.add_argument('--max-bytes-per-file',
                        dest='max_bytes_per_file',
                        type=int,
                        default=1024 * 1024,
                        help='maximum bytes per file')
    parser.add_argument('--num-subdirs',
                        dest='num_subdirs',
                        type=int,
                        default=1,
                        help='number of subdirectories at every level')
    parser.add_argument('--num-levels',
                        dest='num_levels',
                        type=int,
                        default=0,
                        help='number of levels below outdir')
    parser.add_argument('--min-dirname-length',
                        dest='min_dirname_length',
                        type=int,
                        default=10,
                        help='minimum length of directory names')
    parser.add_argument('--max-dirname-length',
                        dest='max_dirname_length',
                        type=int,
                        default=10,
                        help='maximum length of directory names')
    parser.add_argument('--min-filename-length',
                        dest='min_filename_length',
                        type=int,
                        default=10,
                        help='minimum length of file names')
    parser.add_argument('--max-filename-length',
                        dest='max_filename_length',
                        type=int,
                        default=10,
                        help='maximum length of file names')

    args = parser.parse_args()
    name_chars = list(range(48, 57)) + list(range(65, 90)) + list(range(97, 122))

    if os.path.exists(args.outdir):
        shutil.rmtree(args.outdir)

    os.mkdir(args.outdir)
    create_random_subdirs(dir=args.outdir,
                          num=args.num_subdirs,
                          name_creator=random_name_creator(name_chars, args.min_dirname_length, args.max_dirname_length),
                          levels=args.num_levels)
    create_random_files(dir=args.outdir,
                        num=args.files_per_dir,
                        name_creator=random_name_creator(name_chars, args.min_filename_length, args.max_filename_length),
                        minbytes=args.min_bytes_per_file,
                        maxbytes=args.max_bytes_per_file,
                        level=args.num_levels)


if __name__ == '__main__':
    main()
