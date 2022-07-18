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


def create_random_subdirs(dir, num, name_chars, minlen, maxlen, levels):
    for i in range(num):
        random_dir = '{}/{}'.format(dir, create_random_name(5, 10, name_chars))
        os.mkdir(random_dir)
        if levels > 0:
            create_random_subdirs(random_dir, num, name_chars, minlen, maxlen, levels - 1)


def create_random_files(dir, num, name_chars, minlen, maxlen, minbytes, maxbytes, level):
    if level == 0:
        for i in range(num):
            random_file = '{}/{}.bin'.format(dir, create_random_name(minlen, maxlen, name_chars))
            create_random_file(random_file, minbytes, maxbytes)
    else:
        for f in os.listdir(dir):
            create_random_files('{}/{}'.format(dir, f), num, name_chars, minlen, maxlen, minbytes, maxbytes, level - 1)


def main():
    parser = argparse.ArgumentParser(add_help=True)
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
    create_random_subdirs(args.outdir, args.num_subdirs, name_chars, args.min_dirname_length, args.max_dirname_length, args.num_levels)
    create_random_files(args.outdir, args.files_per_dir, name_chars, args.min_filename_length, args.max_filename_length, args.min_bytes_per_file, args.max_bytes_per_file, args.num_levels)


if __name__ == '__main__':
    main()
